variable "default_tags" {}
variable "region" {}
variable "vpc_id" {}
variable "common_security_group" {}
variable "subnets" {}
variable "internal" { default = true }
variable "port" { default = 80 }
variable "protocol" { default = "HTTP" }
variable "enable_stickiness" { default = true }
