resource "aws_vpc" "default" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

# resource "aws_subnet" "public" {
#   count = length(var.subnet_cidrs_public)

#   vpc_id = aws_vpc.default.id
#   cidr_block = var.subnet_cidrs_public[count.index]
#   availability_zone = var.availability_zones[count.index]

#   tags = {
#     Name = var.public_subnet_tags[count.index]
#   }
# }

resource "aws_subnet" "subnet_public-A" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "Public-subnet-A"
  }
}

resource "aws_subnet" "subnet_public-B" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.aws_region}c"
  tags = {
    Name = "Public-subnet-B"
  }
}

resource "aws_subnet" "subnet_private-A" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "Private-A"
  }
}

resource "aws_subnet" "subnet_private-B" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "${var.aws_region}c"
  tags = {
    Name = "Private-B"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "VPC IGW"
  }
}

resource "aws_route_table" "web-public-rt" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
    
  } 

  tags = {
    Name = "Public Subnet RT"
  }
}

# resource "aws_route_table_association" "web-public-rt" {
#   count = length(var.subnet_cidrs_public)

#   subnet_id      = element(aws_subnet.public.*.id, count.index)
#   route_table_id = aws_route_table.web-public-rt.id

# }

resource "aws_route_table_association" "web-public-rt" {
  subnet_id      = aws_subnet.subnet_public-A.id
  route_table_id = aws_route_table.web-public-rt.id
}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public-B.id
  route_table_id = aws_route_table.web-public-rt.id
}

resource "aws_route_table" "web-private-rt" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "Private Subnet RT"
  }
}

resource "aws_route_table_association" "web-private-rt" {

  subnet_id      = aws_subnet.subnet_private-A.id
  route_table_id = aws_route_table.web-private-rt.id

}

resource "aws_route_table_association" "rta_subnet_private" {
  subnet_id      = aws_subnet.subnet_private-B.id
  route_table_id = aws_route_table.web-private-rt.id
}