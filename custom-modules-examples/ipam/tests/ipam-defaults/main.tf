module "ipam_pool" {
  source = "../../../../custom-modules-examples/ipam"

  ipam_cidr   = "10.0.0.0/8"
  home_region = var.region
}
