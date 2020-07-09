#### RDS Stack ####
#
# This module will deploy a sample RDS Aurora Cluster across three availability zones.
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

data "aws_vpc" "vpc" {
    tags = {
        Name = "terraform-vpc"
    }
}

data "aws_subnet_ids" "private" {
    vpc_id = data.aws_vpc.vpc.id
    tags = {
        Tier = "Private"
    }
}

data "aws_secretsmanager_secret" "secret" {
  name = "sample-rds-credentials"
  depends_on = [
    aws_cloudformation_stack.rdscredentials
  ]
}

data "aws_secretsmanager_secret_version" "secret" {
    secret_id = data.aws_secretsmanager_secret.secret.id
}

resource "aws_security_group" "rds" {
    name = "sample-rds-securitygroup"
    description = "Allows SQL 3306 access to our RDS instance from the VPC CIDR"
    vpc_id = data.aws_vpc.vpc.id
    ingress {
        description = "Allows SQL 3306 access to our RDS instance from the VPC CIDR"
        protocol = "tcp"
        from_port = 3306
        to_port = 3306
        cidr_blocks = [data.aws_vpc.vpc.cidr_block]
    }
    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sample-rds-securitygroup"
    }
}

resource "aws_cloudformation_stack" "rdscredentials" {
    name = "sample-rds-credentials"
    template_body = file("${path.module}/cloudformation.yml")
}

resource "aws_db_subnet_group" "default" {
    name = "sample-rds-subnetgroup"
    description = "Sample RDS Subnet Group created by Terraform"
    subnet_ids = [for id in data.aws_subnet_ids.private.ids : id]
}

resource "aws_rds_cluster" "cluster" {
    cluster_identifier = "sample-rds-cluster"
    final_snapshot_identifier = "sample-rds-snapshot"
    skip_final_snapshot = true
    engine_mode = "serverless"
    engine = "aurora"
    database_name = "RDSSampleDatabase"
    master_username = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["username"]
    master_password = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["password"]
    db_subnet_group_name = aws_db_subnet_group.default.id
    vpc_security_group_ids = [aws_security_group.rds.id]
    availability_zones = [
        data.aws_availability_zones.available.names[0],
        data.aws_availability_zones.available.names[1],
        data.aws_availability_zones.available.names[2]
    ]
    scaling_configuration {
        auto_pause = true
        max_capacity = 256
        min_capacity = 2
        seconds_until_auto_pause = 300
    }
}
