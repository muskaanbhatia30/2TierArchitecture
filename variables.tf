  variable "tier_vpc_tag" {
    description = "name of vpc "
    type = string
    nullable = false
  
}


  variable "public_subnet_name" {
    description = "name of the subnet "
    type = string
    nullable = false
  
}

  variable "private_subnet_name" {
    description = "name of the subnet "
    type = string
    nullable = false
  
}

variable "tier_nat" {
    description = "name of nat gateway "
    type = string
    nullable = false
}

variable "public_route_table" {
    description = "name of nat gateway "
    type = string
    nullable = false
}

variable "private_route_table" {
    description = "name of private route table "
    type = string
    nullable = false
}

variable "name_launch_template" {
  type = string
  description = "launch template name"
  nullable = false
}

variable "name_autoScale" {
  description = "The autoscale"
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

variable "name_lb" {
  description = "The load balancer of the VPC"
  type        = string
}

variable "name_lb_target_group" {
  description = "The target group of vpc"
  type        = string
}
