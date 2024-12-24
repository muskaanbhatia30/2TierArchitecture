output "vpc_id" {
  value = aws_vpc.tier_vpc.id
  description = "The ID of the VPC"
}

output "private_subnet_id" {
  value = [for subnet in aws_subnet.private_subnet : subnet.id]
  description = "The ID of the private subnets"
}

output "public_subnet_id" {
  value = [for subnet in aws_subnet.public_subnet : subnet.id]
  description = "The ID of the public subnets"
}