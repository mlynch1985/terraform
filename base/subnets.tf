## Define Public Subnets
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.namespace}_public_a"
    Environment = var.environment
    Namespace   = var.namespace
    Tier        = "public"
  }
}
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.namespace}_public_b"
    Environment = var.environment
    Namespace   = var.namespace
    Tier        = "public"
  }
}
resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = data.aws_availability_zones.zones.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.namespace}_public_c"
    Environment = var.environment
    Namespace   = var.namespace
    Tier        = "public"
  }
}

## Associate Public Subnets to Internet Gateway
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.rtb_public.id
}
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.rtb_public.id
}
resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.rtb_public.id
}


## Define Private Subnets
resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = data.aws_availability_zones.zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.namespace}_private_a"
    Environment = var.environment
    Namespace   = var.namespace
    Tier        = "private"
  }
}
resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = data.aws_availability_zones.zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.namespace}_private_b"
    Environment = var.environment
    Namespace   = var.namespace
    Tier        = "private"
  }
}
resource "aws_subnet" "private_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.13.0/24"
  availability_zone       = data.aws_availability_zones.zones.names[2]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.namespace}_private_c"
    Environment = var.environment
    Namespace   = var.namespace
    Tier        = "private"
  }
}


## Associate Private Subnets to NAT Gateways
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.rtb_private_a.id
}
resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.rtb_private_b.id
}
resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.rtb_private_c.id
}
