#### VPC Stack ####
#
# This module will deploy a 10.0.0.0/16 VPC with 3 Public and 3 Private /24 subnets
#
###################

variable "region" { default = "us-east-1" }
variable "cidrblock" { default = "10.0.0.0/16"}

provider "aws" {
    region  = var.region
    version = "~> 2.69"
}

locals {
    zones = ["A", "B", "C"]
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
    cidr_block = var.cidrblock
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "terraform-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "terraform-igw"
    }
}

resource "aws_eip" "eip" {
    count = length(local.zones)
    tags = {
        Name = "EIP-${element(local.zones, count.index)}"
    }
}

resource "aws_subnet" "public" {
    count = length(local.zones)
    vpc_id = aws_vpc.vpc.id
    cidr_block = cidrsubnet(var.cidrblock, 8, count.index)
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    map_public_ip_on_launch = true
    tags = {
        Name = "Public-${element(local.zones, count.index)}"
        Tier = "Public"
    }
}

resource "aws_subnet" "private" {
    count = length(local.zones)
    vpc_id = aws_vpc.vpc.id
    cidr_block = cidrsubnet(var.cidrblock, 8, count.index + length(local.zones))
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    map_public_ip_on_launch = false
    tags = {
        Name = "Private-${element(local.zones, count.index)}"
        Tier = "Private"
    }
}

resource "aws_nat_gateway" "ngw" {
    count = length(local.zones)
    allocation_id = element(aws_eip.eip.*.id, count.index)
    subnet_id = element(aws_subnet.public.*.id, count.index)
    tags = {
        Name = "NGW-${element(local.zones, count.index)}"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "Public"
    }
}

resource "aws_route_table" "private" {
    count = length(local.zones)
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
    }
    tags = {
        Name = "Private-${element(local.zones, count.index)}"
    }
}

resource "aws_route_table_association" "public" {
    count = length(local.zones)
    subnet_id = element(aws_subnet.public.*.id, count.index)
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count = length(local.zones)
    subnet_id = element(aws_subnet.private.*.id, count.index)
    route_table_id = element(aws_route_table.private.*.id, count.index)
}
