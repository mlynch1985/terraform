#### ECS Stack ####
#
# This module will deploy a sample ECS Cluster hosting a PHP site across two availability zones.
#
###################

variable "region" { default = "us-east-1" }

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

data "aws_vpc" "vpc" {
    tags = {
        Name = "terraform-vpc"
    }
}

data "aws_subnet_ids" "public" {
    vpc_id = data.aws_vpc.vpc.id
    tags = {
        Tier = "Public"
    }
}

data "aws_subnet_ids" "private" {
    vpc_id = data.aws_vpc.vpc.id
    tags = {
        Tier = "Private"
    }
}
