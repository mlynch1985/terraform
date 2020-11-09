#### ECS Stack ####
#
# This module will deploy a sample Microsoft Active Directory service and a single EC2 instanace auto-joined to the domain
#
###################

variable "region" { default = "us-east-1" }

provider "aws" {
    region  = var.region
    version = "~> 2.69"
}

data "aws_availability_zones" "available" {
    state = "available"
}

data "aws_ami" "windows-2019" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["Windows_Server-2019-English-Full-Base*"]
    }
}

data "aws_vpc" "vpc" {
    tags = {
        Name = "terraform-vpc"
    }
}

data "aws_subnet" "public-a" {
    vpc_id = data.aws_vpc.vpc.id
    tags = {
        Name = "Public-A"
    }
}

data "aws_subnet" "private-a" {
    vpc_id = data.aws_vpc.vpc.id
    tags = {
        Name = "Private-A"
    }
}

data "aws_subnet" "private-b" {
    vpc_id = data.aws_vpc.vpc.id
    tags = {
        Name = "Private-B"
    }
}

# data "aws_subnet_ids" "public" {
#     vpc_id = data.aws_vpc.vpc.id
#     tags = {
#         Tier = "Public"
#     }
# }

# data "aws_subnet_ids" "private" {
#     vpc_id = data.aws_vpc.vpc.id
#     tags = {
#         Tier = "Private"
#     }
# }

# data "aws_subnet" "public" {
#     count = length(data.aws_subnet_ids.public.ids)
#     id = tolist(data.aws_subnet_ids.public.ids)[count.index]
# }

# data "aws_subnet" "private" {
#     count = length(data.aws_subnet_ids.private.ids)
#     id = tolist(data.aws_subnet_ids.private.ids)[count.index]
# }
