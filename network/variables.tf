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
    description = "name of public route table "
    type = string
    nullable = false
}

variable "private_route_table" {
    description = "name of private route table "
    type = string
    nullable = false
}

