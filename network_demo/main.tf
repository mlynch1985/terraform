##########################################################################
# DEFINE ENVIRONMENT INFORMATION
##########################################################################

locals {
  region1_name        = "us-east-1"
  region1_az_zone_ids = ["use1-az1", "use1-az2", "use1-az4"] # Currently az3 is not supported in Virginia
  region2_name        = "us-east-2"
  region2_az_zone_ids = ["use2-az1", "use2-az2", "use2-az3"]
  region3_name        = "us-west-2"
  region3_az_zone_ids = ["usw2-az1", "usw2-az2", "usw2-az3"]
}

data "aws_caller_identity" "current" {}

##########################################################################
# DEPLOY TRANSIT GATEWAYS
##########################################################################

module "tgw_region1" {
  source = "./modules/tgw"

  name                                   = "main"
  enable_default_route_table_association = false
  enable_default_route_table_propagation = false
  enable_auto_accept_shared_attachments  = false
  enable_mutlicast_support               = false
  enable_vpn_ecmp_support                = false
  enable_dns_support                     = true
  ram_name                               = ""
  ram_principals                         = []

  providers = {
    aws = aws.region1
  }
}

module "tgw_region2" {
  source = "./modules/tgw"

  name                                   = "main"
  enable_default_route_table_association = false
  enable_default_route_table_propagation = false
  enable_auto_accept_shared_attachments  = false
  enable_mutlicast_support               = false
  enable_vpn_ecmp_support                = false
  enable_dns_support                     = true
  ram_name                               = ""
  ram_principals                         = []

  providers = {
    aws = aws.region2
  }
}

module "tgw_region3" {
  source = "./modules/tgw"

  name                                   = "main"
  enable_default_route_table_association = false
  enable_default_route_table_propagation = false
  enable_auto_accept_shared_attachments  = false
  enable_mutlicast_support               = false
  enable_vpn_ecmp_support                = false
  enable_dns_support                     = true
  ram_name                               = ""
  ram_principals                         = []

  providers = {
    aws = aws.region3
  }
}

##########################################################################
# CONFIGURE TRANSIT GATEWAY CROSS REGION PEERING
##########################################################################

resource "aws_ec2_transit_gateway_peering_attachment" "region1_to_region2" {
  peer_account_id         = data.aws_caller_identity.current.account_id
  peer_region             = local.region2_name
  peer_transit_gateway_id = module.tgw_region2.ec2_transit_gateway_id
  transit_gateway_id      = module.tgw_region1.ec2_transit_gateway_id

  tags = {
    "Name" = "tgw_peer_region1_to_region2"
  }

  provider = aws.region1
}

resource "aws_ec2_transit_gateway_peering_attachment" "region1_to_region3" {
  peer_account_id         = data.aws_caller_identity.current.account_id
  peer_region             = local.region3_name
  peer_transit_gateway_id = module.tgw_region3.ec2_transit_gateway_id
  transit_gateway_id      = module.tgw_region1.ec2_transit_gateway_id

  tags = {
    "Name" = "tgw_peer_region1_to_region3"
  }

  provider = aws.region1
}

resource "aws_ec2_transit_gateway_peering_attachment" "region2_to_region3" {
  peer_account_id         = data.aws_caller_identity.current.account_id
  peer_region             = local.region3_name
  peer_transit_gateway_id = module.tgw_region3.ec2_transit_gateway_id
  transit_gateway_id      = module.tgw_region2.ec2_transit_gateway_id

  tags = {
    "Name" = "tgw_peer_region2_to_region3"
  }

  provider = aws.region2
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "region2_to_region1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region2.id

  tags = {
    "Name" = "tgw_peer_region2_to_region1"
  }

  provider = aws.region2
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "region3_to_region1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region3.id

  tags = {
    "Name" = "tgw_peer_region3_to_region1"
  }

  provider = aws.region3
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "region3_to_region2" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.region2_to_region3.id

  tags = {
    "Name" = "tgw_peer_region3_to_region2"
  }

  provider = aws.region3
}

##########################################################################
# DEPLOY INSPECTION VPCs
##########################################################################

module "vpc_region1_inspection" {
  source = "./modules/vpc"

  name                    = "inspection"
  azs                     = local.region1_az_zone_ids
  cidr_block              = "10.10.0.0/24"
  enable_dns_hostnames    = false
  enable_dns_support      = true
  enable_firewall         = true
  enable_internet_gateway = false
  enable_nat_gateway      = false
  public_subnet_names     = []
  public_subnets          = []
  private_subnet_names    = ["inspection_private_a", "inspection_private_b", "inspection_private_c"]
  private_subnets         = ["10.10.0.64/26", "10.10.0.128/26", "10.10.0.192/26"]
  transit_subnet_names    = ["inspection_transit_a", "inspection_transit_b", "inspection_transit_c"]
  transit_subnets         = ["10.10.0.0/28", "10.10.0.16/28", "10.10.0.32/28"]
  secondary_cidr_blocks   = []
  tgw_cidr_route          = "0.0.0.0/0"
  tgw_id                  = module.tgw_region1.ec2_transit_gateway_id
  appliance_mode_support  = "enable"

  providers = {
    aws = aws.region1
  }
}

module "vpc_region2_inspection" {
  source = "./modules/vpc"

  name                    = "inspection"
  azs                     = local.region2_az_zone_ids
  cidr_block              = "10.20.0.0/24"
  enable_dns_hostnames    = false
  enable_dns_support      = true
  enable_firewall         = true
  enable_internet_gateway = false
  enable_nat_gateway      = false
  public_subnet_names     = []
  public_subnets          = []
  private_subnet_names    = ["inspection_private_a", "inspection_private_b", "inspection_private_c"]
  private_subnets         = ["10.20.0.64/26", "10.20.0.128/26", "10.20.0.192/26"]
  transit_subnet_names    = ["inspection_transit_a", "inspection_transit_b", "inspection_transit_c"]
  transit_subnets         = ["10.20.0.0/28", "10.20.0.16/28", "10.20.0.32/28"]
  secondary_cidr_blocks   = []
  tgw_cidr_route          = "0.0.0.0/0"
  tgw_id                  = module.tgw_region2.ec2_transit_gateway_id
  appliance_mode_support  = "enable"

  providers = {
    aws = aws.region2
  }
}

module "vpc_region3_inspection" {
  source = "./modules/vpc"

  name                    = "inspection"
  azs                     = local.region3_az_zone_ids
  cidr_block              = "10.30.0.0/24"
  enable_dns_hostnames    = false
  enable_dns_support      = true
  enable_firewall         = true
  enable_internet_gateway = false
  enable_nat_gateway      = false
  public_subnet_names     = []
  public_subnets          = []
  private_subnet_names    = ["inspection_private_a", "inspection_private_b", "inspection_private_c"]
  private_subnets         = ["10.30.0.64/26", "10.30.0.128/26", "10.30.0.192/26"]
  transit_subnet_names    = ["inspection_transit_a", "inspection_transit_b", "inspection_transit_c"]
  transit_subnets         = ["10.30.0.0/28", "10.30.0.16/28", "10.30.0.32/28"]
  secondary_cidr_blocks   = []
  tgw_cidr_route          = "0.0.0.0/0"
  tgw_id                  = module.tgw_region3.ec2_transit_gateway_id
  appliance_mode_support  = "enable"

  providers = {
    aws = aws.region3
  }
}

##########################################################################
# DEPLOY EGRESS VPCs
##########################################################################

module "vpc_region1_egress" {
  source = "./modules/vpc"

  name                    = "egress"
  azs                     = local.region1_az_zone_ids
  cidr_block              = "10.10.1.0/24"
  enable_dns_hostnames    = false
  enable_dns_support      = true
  enable_firewall         = false
  enable_internet_gateway = true
  enable_nat_gateway      = true
  public_subnet_names     = ["egress_public_a", "egress_public_b", "egress_public_c"]
  public_subnets          = ["10.10.1.160/27", "10.10.1.192/27", "10.10.1.224/27"]
  private_subnet_names    = ["egress_private_a", "egress_private_b", "egress_private_c"]
  private_subnets         = ["10.10.1.64/27", "10.10.1.96/27", "10.10.1.128/27"]
  transit_subnet_names    = ["egress_transit_a", "egress_transit_b", "egress_transit_c"]
  transit_subnets         = ["10.10.1.0/28", "10.10.1.16/28", "10.10.1.32/28"]
  secondary_cidr_blocks   = []
  tgw_cidr_route          = "10.0.0.0/8"
  tgw_id                  = module.tgw_region1.ec2_transit_gateway_id
  appliance_mode_support  = "enable"

  providers = {
    aws = aws.region1
  }
}

module "vpc_region2_egress" {
  source = "./modules/vpc"

  name                    = "egress"
  azs                     = local.region2_az_zone_ids
  cidr_block              = "10.20.1.0/24"
  enable_dns_hostnames    = false
  enable_dns_support      = true
  enable_firewall         = false
  enable_internet_gateway = true
  enable_nat_gateway      = true
  public_subnet_names     = ["egress_public_a", "egress_public_b", "egress_public_c"]
  public_subnets          = ["10.20.1.160/27", "10.20.1.192/27", "10.20.1.224/27"]
  private_subnet_names    = ["egress_private_a", "egress_private_b", "egress_private_c"]
  private_subnets         = ["10.20.1.64/27", "10.20.1.96/27", "10.20.1.128/27"]
  transit_subnet_names    = ["egress_transit_a", "egress_transit_b", "egress_transit_c"]
  transit_subnets         = ["10.20.1.0/28", "10.20.1.16/28", "10.20.1.32/28"]
  secondary_cidr_blocks   = []
  tgw_cidr_route          = "10.0.0.0/8"
  tgw_id                  = module.tgw_region2.ec2_transit_gateway_id
  appliance_mode_support  = "enable"

  providers = {
    aws = aws.region2
  }
}

module "vpc_region3_egress" {
  source = "./modules/vpc"

  name                    = "egress"
  azs                     = local.region3_az_zone_ids
  cidr_block              = "10.30.1.0/24"
  enable_dns_hostnames    = false
  enable_dns_support      = true
  enable_firewall         = false
  enable_internet_gateway = true
  enable_nat_gateway      = true
  public_subnet_names     = ["egress_public_a", "egress_public_b", "egress_public_c"]
  public_subnets          = ["10.30.1.160/27", "10.30.1.192/27", "10.30.1.224/27"]
  private_subnet_names    = ["egress_private_a", "egress_private_b", "egress_private_c"]
  private_subnets         = ["10.30.1.64/27", "10.30.1.96/27", "10.30.1.128/27"]
  transit_subnet_names    = ["egress_transit_a", "egress_transit_b", "egress_transit_c"]
  transit_subnets         = ["10.30.1.0/28", "10.30.1.16/28", "10.30.1.32/28"]
  secondary_cidr_blocks   = []
  tgw_cidr_route          = "10.0.0.0/8"
  tgw_id                  = module.tgw_region3.ec2_transit_gateway_id
  appliance_mode_support  = "enable"

  providers = {
    aws = aws.region3
  }
}

##########################################################################
# DEPLOY SPOKE VPCs
##########################################################################

module "vpc_region1_spoke" {
  source = "./modules/vpc"

  name                    = "spoke"
  azs                     = local.region1_az_zone_ids
  cidr_block              = "10.10.5.0/24"
  enable_dns_hostnames    = true
  enable_dns_support      = true
  enable_firewall         = false
  enable_internet_gateway = false
  enable_nat_gateway      = false
  public_subnet_names     = []
  public_subnets          = []
  private_subnet_names    = ["spoke_private_a", "spoke_private_b", "spoke_private_c"]
  private_subnets         = ["10.10.5.64/26", "10.10.5.128/26", "10.10.5.192/26"]
  transit_subnet_names    = ["spoke_transit_a", "spoke_transit_b", "spoke_transit_c"]
  transit_subnets         = ["10.10.5.0/28", "10.10.5.16/28", "10.10.5.32/28"]
  secondary_cidr_blocks   = []
  tgw_cidr_route          = "0.0.0.0/0"
  tgw_id                  = module.tgw_region1.ec2_transit_gateway_id
  appliance_mode_support  = "enable"

  providers = {
    aws = aws.region1
  }
}

module "vpc_region2_spoke" {
  source = "./modules/vpc"

  name                    = "spoke"
  azs                     = local.region2_az_zone_ids
  cidr_block              = "10.20.5.0/24"
  enable_dns_hostnames    = true
  enable_dns_support      = true
  enable_firewall         = false
  enable_internet_gateway = false
  enable_nat_gateway      = false
  public_subnet_names     = []
  public_subnets          = []
  private_subnet_names    = ["spoke_private_a", "spoke_private_b", "spoke_private_c"]
  private_subnets         = ["10.20.5.64/26", "10.20.5.128/26", "10.20.5.192/26"]
  transit_subnet_names    = ["spoke_transit_a", "spoke_transit_b", "spoke_transit_c"]
  transit_subnets         = ["10.20.5.0/28", "10.20.5.16/28", "10.20.5.32/28"]
  secondary_cidr_blocks   = []
  tgw_cidr_route          = "0.0.0.0/0"
  tgw_id                  = module.tgw_region2.ec2_transit_gateway_id
  appliance_mode_support  = "enable"

  providers = {
    aws = aws.region2
  }
}

module "vpc_region3_spoke" {
  source = "./modules/vpc"

  name                    = "spoke"
  azs                     = local.region3_az_zone_ids
  cidr_block              = "10.30.5.0/24"
  enable_dns_hostnames    = true
  enable_dns_support      = true
  enable_firewall         = false
  enable_internet_gateway = false
  enable_nat_gateway      = false
  public_subnet_names     = []
  public_subnets          = []
  private_subnet_names    = ["spoke_private_a", "spoke_private_b", "spoke_private_c"]
  private_subnets         = ["10.30.5.64/26", "10.30.5.128/26", "10.30.5.192/26"]
  transit_subnet_names    = ["spoke_transit_a", "spoke_transit_b", "spoke_transit_c"]
  transit_subnets         = ["10.30.5.0/28", "10.30.5.16/28", "10.30.5.32/28"]
  secondary_cidr_blocks   = []
  tgw_cidr_route          = "0.0.0.0/0"
  tgw_id                  = module.tgw_region3.ec2_transit_gateway_id
  appliance_mode_support  = "enable"

  providers = {
    aws = aws.region3
  }
}

##########################################################################
# CONFIGURE TGW ROUTE TABLES FOR INSPECTION VPCs
##########################################################################

module "tgw_rtb_inspection_region1" {
  source = "./modules/tgw_route_table"

  rtb_name             = "inspection"
  source_attachment_id = module.vpc_region1_inspection.tgw_attachment_id[0]
  tgw_id               = module.tgw_region1.ec2_transit_gateway_id

  routes = {
    "egress" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_region1_egress.tgw_attachment_id[0]
    }
    "region2_peer" = {
      cidr_block           = "10.20.0.0/16"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region2.id
    }
    "region3_peer" = {
      cidr_block           = "10.30.0.0/16"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region3.id
    }
    "spoke" = {
      cidr_block           = "10.10.5.0/24"
      target_attachment_id = module.vpc_region1_spoke.tgw_attachment_id[0]
    }
  }

  providers = {
    aws = aws.region1
  }
}

module "tgw_rtb_inspection_region2" {
  source = "./modules/tgw_route_table"

  rtb_name             = "inspection"
  source_attachment_id = module.vpc_region2_inspection.tgw_attachment_id[0]
  tgw_id               = module.tgw_region2.ec2_transit_gateway_id

  routes = {
    "egress" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_region2_egress.tgw_attachment_id[0]
    }
    "region1_peer" = {
      cidr_block           = "10.10.0.0/16"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region2.id
    }
    "region3_peer" = {
      cidr_block           = "10.30.0.0/16"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region2_to_region3.id
    }
    "spoke" = {
      cidr_block           = "10.20.5.0/24"
      target_attachment_id = module.vpc_region2_spoke.tgw_attachment_id[0]
    }
  }

  providers = {
    aws = aws.region2
  }
}

module "tgw_rtb_inspection_region3" {
  source = "./modules/tgw_route_table"

  rtb_name             = "inspection"
  source_attachment_id = module.vpc_region3_inspection.tgw_attachment_id[0]
  tgw_id               = module.tgw_region3.ec2_transit_gateway_id

  routes = {
    "egress" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_region3_egress.tgw_attachment_id[0]
    }
    "region1_peer" = {
      cidr_block           = "10.10.0.0/16"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region3.id
    }
    "region2_peer" = {
      cidr_block           = "10.20.0.0/16"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region2_to_region3.id
    }
    "spoke" = {
      cidr_block           = "10.30.5.0/24"
      target_attachment_id = module.vpc_region3_spoke.tgw_attachment_id[0]
    }
  }

  providers = {
    aws = aws.region3
  }
}

##########################################################################
# CONFIGURE TGW ROUTE TABLES FOR EGRESS VPCs
##########################################################################

module "tgw_rtb_egress_region1" {
  source = "./modules/tgw_route_table"

  rtb_name             = "egress"
  source_attachment_id = module.vpc_region1_egress.tgw_attachment_id[0]
  tgw_id               = module.tgw_region1.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_region1_inspection.tgw_attachment_id[0]
    }
  }

  providers = {
    aws = aws.region1
  }
}

module "tgw_rtb_egress_region2" {
  source = "./modules/tgw_route_table"

  rtb_name             = "egress"
  source_attachment_id = module.vpc_region2_egress.tgw_attachment_id[0]
  tgw_id               = module.tgw_region2.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_region2_inspection.tgw_attachment_id[0]
    }
  }

  providers = {
    aws = aws.region2
  }
}

module "tgw_rtb_egress_region3" {
  source = "./modules/tgw_route_table"

  rtb_name             = "egress"
  source_attachment_id = module.vpc_region3_egress.tgw_attachment_id[0]
  tgw_id               = module.tgw_region3.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_region3_inspection.tgw_attachment_id[0]
    }
  }

  providers = {
    aws = aws.region3
  }
}

##########################################################################
# CONFIGURE TGW ROUTE TABLES FOR SPOKE VPCs
##########################################################################

module "tgw_rtb_spoke_region1" {
  source = "./modules/tgw_route_table"

  rtb_name             = "spoke"
  source_attachment_id = module.vpc_region1_spoke.tgw_attachment_id[0]
  tgw_id               = module.tgw_region1.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_region1_inspection.tgw_attachment_id[0]
    }
  }

  providers = {
    aws = aws.region1
  }
}

module "tgw_rtb_spoke_region2" {
  source = "./modules/tgw_route_table"

  rtb_name             = "spoke"
  source_attachment_id = module.vpc_region2_spoke.tgw_attachment_id[0]
  tgw_id               = module.tgw_region2.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_region2_inspection.tgw_attachment_id[0]
    }
  }

  providers = {
    aws = aws.region2
  }
}

module "tgw_rtb_spoke_region3" {
  source = "./modules/tgw_route_table"

  rtb_name             = "spoke"
  source_attachment_id = module.vpc_region3_spoke.tgw_attachment_id[0]
  tgw_id               = module.tgw_region3.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_region3_inspection.tgw_attachment_id[0]
    }
  }

  providers = {
    aws = aws.region3
  }
}

##########################################################################
# CONFIGURE TGW ROUTE TABLES FOR TGW PEERs
##########################################################################

###  REGION 1 ###
module "tgw_rtb_tgw_peer_region1_to_region2" {
  source = "./modules/tgw_route_table"

  rtb_name             = "tgw_peer_region1_to_region2"
  source_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region2.id
  tgw_id               = module.tgw_region1.ec2_transit_gateway_id

  routes = {
    "local_region" = {
      cidr_block           = "10.10.0.0/16"
      target_attachment_id = module.vpc_region1_inspection.tgw_attachment_id[0]
    }
    "peer_region" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region2.id
    }
  }

  providers = {
    aws = aws.region1
  }

  depends_on = [module.tgw_region1, module.tgw_region2, module.tgw_region3]
}

module "tgw_rtb_tgw_peer_region1_to_region3" {
  source = "./modules/tgw_route_table"

  rtb_name             = "tgw_peer_region1_to_region3"
  source_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region3.id
  tgw_id               = module.tgw_region1.ec2_transit_gateway_id

  routes = {
    "local_region" = {
      cidr_block           = "10.10.0.0/16"
      target_attachment_id = module.vpc_region1_inspection.tgw_attachment_id[0]
    }
    "peer_region" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region3.id
    }
  }

  providers = {
    aws = aws.region1
  }

  depends_on = [module.tgw_region1, module.tgw_region2, module.tgw_region3]
}

### REGION 2 ###
module "tgw_rtb_tgw_peer_region2_to_region1" {
  source = "./modules/tgw_route_table"

  rtb_name             = "tgw_peer_region2_to_region1"
  source_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region2.id
  tgw_id               = module.tgw_region2.ec2_transit_gateway_id

  routes = {
    "local_region" = {
      cidr_block           = "10.20.0.0/16"
      target_attachment_id = module.vpc_region2_inspection.tgw_attachment_id[0]
    }
    "peer_region" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region2.id
    }
  }

  providers = {
    aws = aws.region2
  }

  depends_on = [module.tgw_region1, module.tgw_region2, module.tgw_region3]
}

module "tgw_rtb_tgw_peer_region2_to_region3" {
  source = "./modules/tgw_route_table"

  rtb_name             = "tgw_peer_region2_to_region3"
  source_attachment_id = aws_ec2_transit_gateway_peering_attachment.region2_to_region3.id
  tgw_id               = module.tgw_region2.ec2_transit_gateway_id

  routes = {
    "local_region" = {
      cidr_block           = "10.20.0.0/16"
      target_attachment_id = module.vpc_region2_inspection.tgw_attachment_id[0]
    }
    "peer_region" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region2_to_region3.id
    }
  }

  providers = {
    aws = aws.region2
  }

  depends_on = [module.tgw_region1, module.tgw_region2, module.tgw_region3]
}

### REGION 3 ###
module "tgw_rtb_tgw_peer_region3_to_region1" {
  source = "./modules/tgw_route_table"

  rtb_name             = "tgw_peer_region3_to_region1"
  source_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region3.id
  tgw_id               = module.tgw_region3.ec2_transit_gateway_id

  routes = {
    "local_region" = {
      cidr_block           = "10.30.0.0/16"
      target_attachment_id = module.vpc_region3_inspection.tgw_attachment_id[0]
    }
    "peer_region" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region3.id
    }
  }

  providers = {
    aws = aws.region3
  }

  depends_on = [module.tgw_region1, module.tgw_region2, module.tgw_region3]
}

module "tgw_rtb_tgw_peer_region3_to_region2" {
  source = "./modules/tgw_route_table"

  rtb_name             = "tgw_peer_region3_to_region2"
  source_attachment_id = aws_ec2_transit_gateway_peering_attachment.region2_to_region3.id
  tgw_id               = module.tgw_region3.ec2_transit_gateway_id

  routes = {
    "local_region" = {
      cidr_block           = "10.30.0.0/16"
      target_attachment_id = module.vpc_region3_inspection.tgw_attachment_id[0]
    }
    "peer_region" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region2_to_region3.id
    }
  }

  providers = {
    aws = aws.region3
  }

  depends_on = [module.tgw_region1, module.tgw_region2, module.tgw_region3]
}

##########################################################################
# DEPLOY EC2 INSTANCE TO TEST CONNECTIVITY THROUGH SESSION MANAGER
##########################################################################

module "ec2_region1" {
  source = "./modules/ec2"

  subnet_id = module.vpc_region1_spoke.private_subnets[0]
  vpc_id    = module.vpc_region1_spoke.vpc_id

  providers = {
    aws = aws.region1
  }

  depends_on = [module.tgw_rtb_spoke_region1]
}

module "ec2_region2" {
  source = "./modules/ec2"

  subnet_id = module.vpc_region2_spoke.private_subnets[0]
  vpc_id    = module.vpc_region2_spoke.vpc_id

  providers = {
    aws = aws.region2
  }

  depends_on = [module.tgw_rtb_spoke_region2]
}

module "ec2_region3" {
  source = "./modules/ec2"

  subnet_id = module.vpc_region3_spoke.private_subnets[0]
  vpc_id    = module.vpc_region3_spoke.vpc_id

  providers = {
    aws = aws.region3
  }

  depends_on = [module.tgw_rtb_spoke_region3]
}
