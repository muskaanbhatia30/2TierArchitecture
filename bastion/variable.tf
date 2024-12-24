variable "public_subnet_id" {
  type = list(string)
  description = "The id of public subnet"
}


variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "bastion_sg" {
  type = string
  description = "The name of bastion subnet"
}


variable "bastionServer" {
    type = string
   description = "The name of bastion subnet"
}

