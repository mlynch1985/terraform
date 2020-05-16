## Define VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.namespace}-vpc"
    Environment = "${var.environment}"
  }
}


## Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.namespace}-igw"
    Environment = "${var.environment}"
  }
}


## Create Public Route Table
resource "aws_route_table" "rtb-public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.namespace}-rtb-public"
    Environment = "${var.environment}"
  }
}


## Define Elastic IPs for our NAT Gateways
resource "aws_eip" "eip-nat-a" {
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.namespace}-eip-ngw-a"
    Environment = "${var.environment}"
  }
}
resource "aws_eip" "eip-nat-b" {
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.namespace}-eip-ngw-b"
    Environment = "${var.environment}"
  }
}
resource "aws_eip" "eip-nat-c" {
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.namespace}-eip-ngw-c"
    Environment = "${var.environment}"
  }
}


## Define NAT Gateways
resource "aws_nat_gateway" "ngw-private-a" {
  allocation_id = aws_eip.eip-nat-a.id
  subnet_id     = aws_subnet.public-a.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.namespace}-ngw-public-a"
    Environment = "${var.environment}"
  }
}
resource "aws_nat_gateway" "ngw-private-b" {
  allocation_id = aws_eip.eip-nat-b.id
  subnet_id     = aws_subnet.public-b.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.namespace}-ngw-public-b"
    Environment = "${var.environment}"
  }
}
resource "aws_nat_gateway" "ngw-private-c" {
  allocation_id = aws_eip.eip-nat-c.id
  subnet_id     = aws_subnet.public-c.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.namespace}-ngw-public-c"
    Environment = "${var.environment}"
  }
}


## Create Private Route Tables
resource "aws_route_table" "rtb-private-a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-private-a.id
  }

  tags = {
    Name        = "${var.namespace}-rtb-private-a"
    Environment = "${var.environment}"
  }
}
resource "aws_route_table" "rtb-private-b" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-private-b.id
  }

  tags = {
    Name        = "${var.namespace}-rtb-private-b"
    Environment = "${var.environment}"
  }
}
resource "aws_route_table" "rtb-private-c" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-private-c.id
  }

  tags = {
    Name        = "${var.namespace}-rtb-private-c"
    Environment = "${var.environment}"
  }
}
