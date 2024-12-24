#  virtual private cloud 
resource "aws_vpc" "tier_vpc" {
  cidr_block       = "20.0.0.0/16"
  tags = {
    Name =var.tier_vpc_tag
  }
}

// this will fetch the available zones
data "aws_availability_zones" "available" {
  state = "available"
}

# public subnet for two az
resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id     = aws_vpc.tier_vpc.id
  cidr_block = "20.0.${count.index}.0/24"

  tags = {
    Name = "${var.public_subnet_name}-${count.index}"
  }
  availability_zone = data.aws_availability_zones.available.names[count.index]

}


# private subnet for two az
resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id     = aws_vpc.tier_vpc.id
  cidr_block = "20.0.${count.index+2}.0/24"

  tags = {
    Name = "${var.private_subnet_name}-${count.index+2}"
  }
  availability_zone = data.aws_availability_zones.available.names[count.index]

}


// internet gateway 

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tier_vpc.id

  tags = {
    Name = "main"
  }
}

//elastic ip address for the 

resource "aws_eip" "tier_eip" {
  count = 2
  tags = {
    Name = "NATEIP-${count.index}"
  }
}

resource "aws_nat_gateway" "tier_nat" {
  count = 2
  allocation_id = aws_eip.tier_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id # placing nat gatewayin first public subnet

  tags = {
    Name = "${var.tier_nat}-${count.index}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# creating route table for public subnet

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.tier_vpc.id
  tags   = {
     Name = var.public_route_table 
     }
}

# editing route to attach internet gateway to route table
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#  attaching route table to the public subnet
resource "aws_route_table_association" "public_association" {
  count          = 2
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

# ..................Private route Table.............

# Private Route Tables
resource "aws_route_table" "private_route_table" {
  count  = 2 # One route table per private subnet
  vpc_id = aws_vpc.tier_vpc.id

  tags = {
    Name = "${var.private_route_table}-${count.index + 1}"
  }
}

# Routes in Private Route Tables to NAT Gateways
resource "aws_route" "private_route_to_nat" {
  count              = 2
  route_table_id     = aws_route_table.private_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id     = aws_nat_gateway.tier_nat[count.index].id
}

# Associate Private Subnets with Route Tables
resource "aws_route_table_association" "private_association" {
  count          = 2
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}


