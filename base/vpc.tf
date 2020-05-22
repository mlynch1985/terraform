## Define VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.namespace}_vpc"
    Environment = var.environment
    Namespace   = var.namespace
  }
}


## Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.namespace}_igw"
    Environment = var.environment
    Namespace   = var.namespace
  }
}


## Create Public Route Table
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.namespace}_rtb_public"
    Environment = var.environment
    Namespace   = var.namespace
  }
}


## Define Elastic IPs for our NAT Gateways
resource "aws_eip" "eip_nat_a" {
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.namespace}_eip_ngw_a"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
resource "aws_eip" "eip_nat_b" {
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.namespace}_eip_ngw_b"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
resource "aws_eip" "eip_nat_c" {
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.namespace}_eip_ngw_c"
    Environment = var.environment
    Namespace   = var.namespace
  }
}


## Define NAT Gateways
resource "aws_nat_gateway" "ngw_private_a" {
  allocation_id = aws_eip.eip_nat_a.id
  subnet_id     = aws_subnet.public_a.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.namespace}_ngw_public_a"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
resource "aws_nat_gateway" "ngw_private_b" {
  allocation_id = aws_eip.eip_nat_b.id
  subnet_id     = aws_subnet.public_b.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.namespace}_ngw_public_b"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
resource "aws_nat_gateway" "ngw_private_c" {
  allocation_id = aws_eip.eip_nat_c.id
  subnet_id     = aws_subnet.public_c.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.namespace}_ngw_public_c"
    Environment = var.environment
    Namespace   = var.namespace
  }
}


## Create Private Route Tables
resource "aws_route_table" "rtb_private_a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_private_a.id
  }

  tags = {
    Name        = "${var.namespace}_rtb_private_a"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
resource "aws_route_table" "rtb_private_b" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_private_b.id
  }

  tags = {
    Name        = "${var.namespace}_rtb_private_b"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
resource "aws_route_table" "rtb_private_c" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_private_c.id
  }

  tags = {
    Name        = "${var.namespace}_rtb_private_c"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
