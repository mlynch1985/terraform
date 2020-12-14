variable "default_tags" {}
variable "cidr_block" {}

locals {
  namespace = var.default_tags["namespace"]

  component = "vpc"

  default_tags = merge(
    var.default_tags,
    map(
      "component", local.component
    )
  )
}
