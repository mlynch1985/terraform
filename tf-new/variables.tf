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
