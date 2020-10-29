data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" { state = "available" }

variable "default_tags" {
    type = map
    default = {
        lob: "example",
        team: "it operations",
        app: "app1",
        env: "dev",
        namespace: "useast1_dev"
  }
}

variable "region" { default = "us-east-1" }
variable "az_count" { default = 3 }
variable "cidr_block" { default = "10.0.0.0/16" }
