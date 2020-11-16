variable region {}
variable namespace {}
variable bucket {}
variable lob {}
variable team {}
variable environment {}

locals {
  component = "vpc"

  default_tags = {
    namespace : var.namespace,
    component : local.component,
    lob : var.lob,
    team : var.team,
    environment : var.environment
  }
}
