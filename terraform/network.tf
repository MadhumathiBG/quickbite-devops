resource "aws_vpc" "quickbite_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "QuickBite-VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.quickbite_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "QuickBite-Public-Subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.quickbite_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "QuickBite-Private-Subnet"
  }
}

resource "aws_internet_gateway" "quickbite_igw" {
  vpc_id = aws_vpc.quickbite_vpc.id

  tags = {
    Name = "QuickBite-IGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.quickbite_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.quickbite_igw.id
  }

  tags = {
    Name = "QuickBite-Public-RT"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "QuickBite-NAT-EIP"
  }
}

resource "aws_nat_gateway" "quickbite_nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "QuickBite-NAT-Gateway"
  }

  depends_on = [
    aws_internet_gateway.quickbite_igw
  ]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.quickbite_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.quickbite_nat.id
  }

  tags = {
    Name = "QuickBite-Private-RT"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
