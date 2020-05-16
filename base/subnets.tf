## Capture currently availability zones
data "aws_availability_zones" "azs" {
  state = "available"
}


## Define Public Subnets
resource "aws_subnet" "public-a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.namespace}-public-a"
    Environment = var.environment
    Namespace   = var.namespace
    Tier        = "public"
  }
}
resource "aws_subnet" "public-b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.namespace}-public-b"
    Environment = var.environment
    Namespace   = var.namespace
    Tier        = "public"
  }
}
resource "aws_subnet" "public-c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.namespace}-public-c"
    Environment = var.environment
    Namespace   = var.namespace
    Tier        = "public"
  }
}

## Associate Public Subnets to Internet Gateway
resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.rtb-public.id
}
resource "aws_route_table_association" "public-b" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.rtb-public.id
}
resource "aws_route_table_association" "public-c" {
  subnet_id      = aws_subnet.public-c.id
  route_table_id = aws_route_table.rtb-public.id
}


## Define Private Subnets
resource "aws_subnet" "private-a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.namespace}-private-a"
    Environment = var.environment
    Namespace   = var.namespace
    Tier        = "private"
  }
}
resource "aws_subnet" "private-b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.namespace}-private-b"
    Environment = var.environment
    Namespace   = var.namespace
    Tier        = "private"
  }
}
resource "aws_subnet" "private-c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.13.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[2]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.namespace}-private-c"
    Environment = var.environment
    Namespace   = var.namespace
    Tier        = "private"
  }
}


## Associate Private Subnets to NAT Gateways
resource "aws_route_table_association" "private-a" {
  subnet_id      = aws_subnet.private-a.id
  route_table_id = aws_route_table.rtb-private-a.id
}
resource "aws_route_table_association" "private-b" {
  subnet_id      = aws_subnet.private-b.id
  route_table_id = aws_route_table.rtb-private-b.id
}
resource "aws_route_table_association" "private-c" {
  subnet_id      = aws_subnet.private-c.id
  route_table_id = aws_route_table.rtb-private-c.id
}
