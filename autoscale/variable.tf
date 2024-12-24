variable "name_launch_template" {
  type = string
  description = "launch template name"
  nullable = false
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "name_autoScale" {
  description = "The autoscale"
  type        = string
}

variable "private_subnet_id" {
  description = "The ID of the private subnet"
  type = list(string)
}

# variable "bastion_public_ip" {
#   description = "The ID of the private subnet"
#   type = string
# }