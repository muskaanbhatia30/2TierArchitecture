#  creating key for bstion host 

# Generate an SSH key pair
resource "tls_private_key" "instance_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Save the private key locally
resource "local_file" "private_key" {
  content  = tls_private_key.instance_key.private_key_pem
  filename = "${path.module}/bastionkey/bastion_key.pem"
}

# Save the public key locally
resource "local_file" "public_key" {
  content  = tls_private_key.instance_key.public_key_openssh
  filename = "${path.module}/bastionkey/bastion_key.pub"
}


resource "aws_security_group" "bastion_sg" {
  name        = var.bastion_sg
  description = "Allow SSH access to the bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this to your IP in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Register the public key in AWS as a key pair
resource "aws_key_pair" "instance_key" {
  key_name   = "instance-key" # Name of the key pair in AWS
  public_key = tls_private_key.instance_key.public_key_openssh
}


resource "aws_instance" "bastionServer" {
  ami           = "ami-0866a3c8686eaeeba" # Replace with your AMI ID
  instance_type = "t2.micro"
  subnet_id     =var.public_subnet_id[0]


  key_name = aws_key_pair.instance_key.key_name

  security_groups = [
    aws_security_group.bastion_sg.id,
  ]

associate_public_ip_address = true
# Provisioner to copy the private key to the Bastion host
  provisioner "file" {
    source      = "${path.module}/../autoscale/launchkey/launch_key.pem"
    destination = "/home/ubuntu/terraform.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = tls_private_key.instance_key.private_key_pem # where you have to ssh
    }

    
  }

  tags = {
    name= var.bastionServer
    Role="bastion"
  }

}

