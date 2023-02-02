module "tgw_nonprod_use2" {
  source = "./modules/tgw"

  name               = "nonprod"
  enable_dns_support = true
  ram_name           = "nonprod-networking"
  ram_principals = [
    "arn:aws:organizations::525260847144:ou/o-gafjwq0m3x/ou-i8oe-rsjznn5u", # Infra-NonProd
    "arn:aws:organizations::525260847144:ou/o-gafjwq0m3x/ou-i8oe-i4hjybyg"  # Workloads-NonProd
  ]

  providers = {
    aws = aws.nonprod-hub-use2
  }
}

module "vpc_inspection_nonprod_use2" {
  source = "./modules/vpc"

  azs                    = ["use2-az1", "use2-az2", "use2-az3"]
  cidr_block             = "10.10.0.0/24"
  enable_firewall        = true
  name                   = "inspection"
  private_subnet_names   = ["inspection_private_a", "inspection_private_b", "inspection_private_c"]
  private_subnets        = ["10.10.0.64/26", "10.10.0.128/26", "10.10.0.192/26"]
  transit_subnet_names   = ["inspection_transit_a", "inspection_transit_b", "inspection_transit_c"]
  transit_subnets        = ["10.10.0.0/28", "10.10.0.16/28", "10.10.0.32/28"]
  tgw_id                 = module.tgw_nonprod_use2.ec2_transit_gateway_id
  appliance_mode_support = "enable"

  providers = {
    aws = aws.nonprod-hub-use2
  }
}

module "vpc_egress_nonprod_use2" {
  source = "./modules/vpc"

  azs                     = ["use2-az1", "use2-az2", "use2-az3"]
  cidr_block              = "10.10.1.0/24"
  enable_internet_gateway = true
  enable_nat_gateway      = true
  name                    = "egress"
  public_subnet_names     = ["egress_public_a", "egress_public_b", "egress_public_c"]
  public_subnets          = ["10.10.1.160/27", "10.10.1.192/27", "10.10.1.224/27"]
  private_subnet_names    = ["egress_private_a", "egress_private_b", "egress_private_c"]
  private_subnets         = ["10.10.1.64/27", "10.10.1.96/27", "10.10.1.128/27"]
  transit_subnet_names    = ["egress_transit_a", "egress_transit_b", "egress_transit_c"]
  transit_subnets         = ["10.10.1.0/28", "10.10.1.16/28", "10.10.1.32/28"]
  tgw_cidr_route          = "10.0.0.0/8"
  tgw_id                  = module.tgw_nonprod_use2.ec2_transit_gateway_id
  appliance_mode_support  = "enable"

  providers = {
    aws = aws.nonprod-hub-use2
  }
}

module "vpc_spoke_nonprod_use2" {
  source = "./modules/vpc"

  azs                    = ["use2-az1", "use2-az2", "use2-az3"]
  cidr_block             = "10.10.2.0/24"
  name                   = "spoke"
  private_subnet_names   = ["spoke_private_a", "spoke_private_b", "spoke_private_c"]
  private_subnets        = ["10.10.2.64/26", "10.10.2.128/26", "10.10.2.192/26"]
  transit_subnet_names   = ["spoke_transit_a", "spoke_transit_b", "spoke_transit_c"]
  transit_subnets        = ["10.10.2.0/28", "10.10.2.16/28", "10.10.2.32/28"]
  tgw_id                 = module.tgw_nonprod_use2.ec2_transit_gateway_id
  appliance_mode_support = "enable"

  providers = {
    aws = aws.nonprod-spoke-use2
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "vpc_spoke_nonprod_use2" {
  transit_gateway_attachment_id = module.vpc_spoke_nonprod_use2.tgw_attachment_id[0]
  provider                      = aws.nonprod-hub-use2

  tags = {
    Name = "spoke"
  }

  lifecycle {
    ignore_changes = [
      transit_gateway_default_route_table_association,
      transit_gateway_default_route_table_propagation
    ]
  }
}

module "route_table_inspection_use2" {
  source = "./modules/tgw_route_table"

  rtb_name             = "inspection"
  source_attachment_id = module.vpc_inspection_nonprod_use2.tgw_attachment_id[0]
  tgw_id               = module.tgw_nonprod_use2.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_egress_nonprod_use2.tgw_attachment_id[0]
    }
    "spoke" = {
      cidr_block           = "10.10.2.0/24"
      target_attachment_id = module.vpc_spoke_nonprod_use2.tgw_attachment_id[0]
    }
    "peer" = {
      cidr_block           = "10.20.0.0/16"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.nonprod_network.id
    }
  }

  providers = {
    aws = aws.nonprod-hub-use2
  }
}

module "route_table_egress_use2" {
  source = "./modules/tgw_route_table"

  rtb_name             = "egress"
  source_attachment_id = module.vpc_egress_nonprod_use2.tgw_attachment_id[0]
  tgw_id               = module.tgw_nonprod_use2.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_inspection_nonprod_use2.tgw_attachment_id[0]
    }
  }

  providers = {
    aws = aws.nonprod-hub-use2
  }
}

module "route_table_spoke_use2" {
  source = "./modules/tgw_route_table"

  rtb_name             = "spoke"
  source_attachment_id = module.vpc_spoke_nonprod_use2.tgw_attachment_id[0]
  tgw_id               = module.tgw_nonprod_use2.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_inspection_nonprod_use2.tgw_attachment_id[0]
    }
  }

  providers = {
    aws = aws.nonprod-hub-use2
  }
}

module "route_table_peer_use2" {
  source = "./modules/tgw_route_table"

  rtb_name             = "tgw_peer"
  source_attachment_id = aws_ec2_transit_gateway_peering_attachment.nonprod_network.id
  tgw_id               = module.tgw_nonprod_use2.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.nonprod_network.id
    }
    "local" = {
      cidr_block           = "10.10.0.0/16"
      target_attachment_id = module.vpc_inspection_nonprod_use2.tgw_attachment_id[0]
    }
  }

  providers = {
    aws = aws.nonprod-hub-use2
  }
}

data "aws_caller_identity" "nonprod_network" {
  provider = aws.nonprod-hub-use2
}

resource "aws_ec2_transit_gateway_peering_attachment" "nonprod_network" {
  provider                = aws.nonprod-hub-use2
  peer_account_id         = data.aws_caller_identity.nonprod_network.account_id
  peer_region             = "us-west-2"
  peer_transit_gateway_id = module.tgw_nonprod_usw2.ec2_transit_gateway_id
  transit_gateway_id      = module.tgw_nonprod_use2.ec2_transit_gateway_id

  tags = {
    "Name" = "tgw_peer"
  }
}
