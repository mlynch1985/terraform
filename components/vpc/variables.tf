variable "default_tags" {}
variable "cidr_block" {}
variable "subnet_size_offset" {}

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
