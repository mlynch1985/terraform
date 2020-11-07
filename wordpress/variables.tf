variable "namespace" {}
variable "region" {}
variable "lob" {}
variable "team" {}
variable "app_name" {}
variable "environment" {}

locals {
    default_tags = {
        namespace: var.namespace,
        lob: var.lob,
        team: var.team,
        app_name: var.app_name,
        environment: var.environment
    }
}

data "aws_ami" "amazon_linux_2" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm*"]
    }
}