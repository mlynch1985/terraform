resource "aws_vpc_ipam" "this" {
  operating_regions {
    region_name = var.home_region
  }
}

resource "aws_vpc_ipam_pool" "this" {
  address_family                    = "ipv4"
  allocation_default_netmask_length = var.allocation_default_netmask_length
  allocation_max_netmask_length     = var.allocation_max_netmask_length
  allocation_min_netmask_length     = var.allocation_min_netmask_length
  ipam_scope_id                     = aws_vpc_ipam.this.private_default_scope_id
  locale                            = var.home_region
}

resource "aws_vpc_ipam_pool_cidr" "this" {
  cidr         = var.ipam_cidr
  ipam_pool_id = aws_vpc_ipam_pool.this.id

  depends_on = [
    aws_vpc_ipam.this
  ]
}
