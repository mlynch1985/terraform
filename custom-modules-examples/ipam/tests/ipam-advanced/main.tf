module "ipam_pool" {
  source = "../../../../custom-modules-examples/ipam"

  allocation_default_netmask_length = 20
  allocation_max_netmask_length     = 26
  allocation_min_netmask_length     = 16
  ipam_cidr                         = "10.0.0.0/8"
  home_region                       = var.region
}
