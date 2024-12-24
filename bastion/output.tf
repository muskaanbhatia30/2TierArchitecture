# # Output Bastion Host public IP
output "bastion_public_ip" {
  value       = aws_instance.bastionServer.public_ip
  description = "Public IP address of the Bastion Host"
}