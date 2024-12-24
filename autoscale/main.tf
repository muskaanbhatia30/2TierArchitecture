# generating a key for launch template

# Generate an SSH key pair
resource "tls_private_key" "autoscale_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Save the private key locally
resource "local_file" "private_key" {
  content  = tls_private_key.autoscale_key.private_key_openssh
  filename = "${path.module}/launchkey/launch_key.pem"
}

# Save the public key locally
resource "local_file" "public_key" {
  content  = tls_private_key.autoscale_key.public_key_openssh
  filename = "${path.module}/launchkey/launch_key.pub"
}


# creating securitu group for launch template
resource "aws_security_group" "sg_launch_template" {
  name        = "sg_launch_template"
  description = "Allow ssh,http inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg_launch_template"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg_launch_template.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.sg_launch_template.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         =  80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_launch_template.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#Register the public key in AWS as a key pair
resource "aws_key_pair" "autoscale_key" {
  key_name   = "autoscale-key" # Name of the key pair in AWS
  public_key = tls_private_key.autoscale_key.public_key_openssh
}

# creating launch template

resource "aws_launch_template" "tier_launch_template" {
  name_prefix   = var.name_launch_template
  image_id      = "ami-0866a3c8686eaeeba" # Replace with your preferred AMI ID
  instance_type = "t2.micro"

  # Add Security Group directly
  vpc_security_group_ids = [aws_security_group.sg_launch_template.id]


  key_name = aws_key_pair.autoscale_key.key_name
  tags = {
    Role="private"
    Name = var.name_launch_template
  }
}

# auto scalling group

resource "aws_autoscaling_group" "tier_autoScale" {
  name = var.name_autoScale
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = var.private_subnet_id

  launch_template {
    id      = aws_launch_template.tier_launch_template.id
    version = "$Latest"
  }

  health_check_type        = "EC2"
  health_check_grace_period = 300

  tag {
    key= "Role"
    value="private"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
