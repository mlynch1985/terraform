resource "aws_vpc_ipam" "main" {
  operating_regions {
    region_name = var.region
  }

  tags = {
    Test = "Main"
  }

  cascade = true
}

resource "aws_vpc_ipam_pool" "main" {
  address_family                    = "ipv4"
  allocation_default_netmask_length = 16
  ipam_scope_id                     = aws_vpc_ipam.main.private_default_scope_id
  locale                            = var.region
}

resource "aws_vpc_ipam_pool_cidr" "main" {
  cidr         = "10.0.0.0/8"
  ipam_pool_id = aws_vpc_ipam_pool.main.id
}
