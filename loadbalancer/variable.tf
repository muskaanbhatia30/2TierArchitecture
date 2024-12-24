variable "public_subnet_id" {
  description = "The ID of the private subnet"
  type = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "name_lb" {
  description = "The load balancer of the VPC"
  type        = string
}

variable "name_lb_target_group" {
  description = "The target group of lb"
  type        = string
}

variable "name_autoScale" {
  description = "autosale name"
  type = string
}