resource "aws_vpc_ipam" "main" {
  operating_regions {
    region_name = var.region
  }

  cascade = true
}

resource "aws_vpc_ipam_pool" "main" {
  address_family                    = "ipv4"
  allocation_default_netmask_length = var.allocation_default_netmask_length
  ipam_scope_id                     = aws_vpc_ipam.main.private_default_scope_id
  locale                            = var.region
}

resource "aws_vpc_ipam_pool_cidr" "main" {
  cidr         = var.cidr
  ipam_pool_id = aws_vpc_ipam_pool.main.id
}
