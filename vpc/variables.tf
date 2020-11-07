variable "namespace" {}
variable "region" {}
variable "lob" {}
variable "team" {}
variable "environment" {}

locals {
  default_tags = {
    namespace : var.namespace,
    lob : var.lob,
    team : var.team,
    environment : var.environment
  }
}
