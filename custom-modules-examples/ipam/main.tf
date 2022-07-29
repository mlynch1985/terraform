resource "aws_vpc_ipam" "vpc_ipam" {
  operating_regions {
    region_name = var.region
  }
}

resource "aws_vpc_ipam_pool" "vpc_ipam_pool" {
  address_family                    = "ipv4"
  allocation_default_netmask_length = var.allocation_default_netmask_length
  allocation_min_netmask_length     = var.allocation_min_netmask_length
  allocation_max_netmask_length     = var.allocation_max_netmask_length
  ipam_scope_id                     = aws_vpc_ipam.vpc_ipam.private_default_scope_id
  locale                            = var.region
}

resource "aws_vpc_ipam_pool_cidr" "vpc_ipam_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.vpc_ipam_pool.id
  cidr         = var.ipam_cidr
}
