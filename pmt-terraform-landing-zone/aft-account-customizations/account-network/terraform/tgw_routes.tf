# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

##########################################################################
# CONFIGURE TGW DEFAULT ROUTE TABLE
##########################################################################

resource "aws_ec2_transit_gateway_route" "region1" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.vpc_inspection_region1.tgw_attachment_id
  transit_gateway_route_table_id = module.tgw_nonprod_region1.ec2_transit_gateway_association_default_route_table_id
  provider                       = aws.region1
}

resource "aws_ec2_transit_gateway_route" "region2" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.vpc_inspection_region2.tgw_attachment_id
  transit_gateway_route_table_id = module.tgw_nonprod_region2.ec2_transit_gateway_association_default_route_table_id
  provider                       = aws.region2
}

##########################################################################
# CONFIGURE TGW ROUTE TABLES FOR INSPECTION VPCs
##########################################################################

module "tgw_rtb_inspection_region1" {
  source = "./modules/tgw_route_table"

  rtb_name             = "inspection"
  source_attachment_id = module.vpc_inspection_region1.tgw_attachment_id
  tgw_id               = module.tgw_nonprod_region1.ec2_transit_gateway_id

  routes = {
    "egress" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_egress_region1.tgw_attachment_id
    }
    "ingress" = {
      cidr_block           = module.vpc_ingress_region1.vpc_cidr_block
      target_attachment_id = module.vpc_ingress_region1.tgw_attachment_id
    }
    "shared" = {
      cidr_block           = module.vpc_shared_region1.vpc_cidr_block
      target_attachment_id = module.vpc_shared_region1.tgw_attachment_id
    }
    "region2_peer" = {
      cidr_block           = local.region2_pool
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region2.id
    }
  }

  providers = {
    aws = aws.region1
  }

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.region2_to_region1
  ]
}

module "tgw_rtb_inspection_region2" {
  source = "./modules/tgw_route_table"

  rtb_name             = "inspection"
  source_attachment_id = module.vpc_inspection_region2.tgw_attachment_id
  tgw_id               = module.tgw_nonprod_region2.ec2_transit_gateway_id

  routes = {
    "egress" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_egress_region2.tgw_attachment_id
    }
    "ingress" = {
      cidr_block           = module.vpc_ingress_region2.vpc_cidr_block
      target_attachment_id = module.vpc_ingress_region2.tgw_attachment_id
    }
    "shared" = {
      cidr_block           = module.vpc_shared_region2.vpc_cidr_block
      target_attachment_id = module.vpc_shared_region2.tgw_attachment_id
    }
    "region1_peer" = {
      cidr_block           = local.region1_pool
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region2.id
    }
  }

  providers = {
    aws = aws.region2
  }

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.region2_to_region1
  ]
}

##########################################################################
# CONFIGURE TGW ROUTE TABLES FOR EGRESS VPCs
##########################################################################

module "tgw_rtb_egress_region1" {
  source = "./modules/tgw_route_table"

  rtb_name             = "egress"
  source_attachment_id = module.vpc_egress_region1.tgw_attachment_id
  tgw_id               = module.tgw_nonprod_region1.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_inspection_region1.tgw_attachment_id
    }
  }

  providers = {
    aws = aws.region1
  }
}

module "tgw_rtb_egress_region2" {
  source = "./modules/tgw_route_table"

  rtb_name             = "egress"
  source_attachment_id = module.vpc_egress_region2.tgw_attachment_id
  tgw_id               = module.tgw_nonprod_region2.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_inspection_region2.tgw_attachment_id
    }
  }

  providers = {
    aws = aws.region2
  }
}

##########################################################################
# CONFIGURE TGW ROUTE TABLES FOR INGRESS VPCs
##########################################################################

module "tgw_rtb_ingress_region1" {
  source = "./modules/tgw_route_table"

  rtb_name             = "ingress"
  source_attachment_id = module.vpc_ingress_region1.tgw_attachment_id
  tgw_id               = module.tgw_nonprod_region1.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_inspection_region1.tgw_attachment_id
    }
  }

  providers = {
    aws = aws.region1
  }
}

module "tgw_rtb_ingress_region2" {
  source = "./modules/tgw_route_table"

  rtb_name             = "ingress"
  source_attachment_id = module.vpc_ingress_region2.tgw_attachment_id
  tgw_id               = module.tgw_nonprod_region2.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_inspection_region2.tgw_attachment_id
    }
  }

  providers = {
    aws = aws.region2
  }
}

##########################################################################
# CONFIGURE TGW ROUTE TABLES FOR SHARED VPCs
##########################################################################

module "tgw_rtb_shared_region1" {
  source = "./modules/tgw_route_table"

  rtb_name             = "shared"
  source_attachment_id = module.vpc_shared_region1.tgw_attachment_id
  tgw_id               = module.tgw_nonprod_region1.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_inspection_region1.tgw_attachment_id
    }
  }

  providers = {
    aws = aws.region1
  }
}

module "tgw_rtb_shared_region2" {
  source = "./modules/tgw_route_table"

  rtb_name             = "shared"
  source_attachment_id = module.vpc_shared_region2.tgw_attachment_id
  tgw_id               = module.tgw_nonprod_region2.ec2_transit_gateway_id

  routes = {
    "default" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = module.vpc_inspection_region2.tgw_attachment_id
    }
  }

  providers = {
    aws = aws.region2
  }
}

##########################################################################
# CONFIGURE TGW ROUTE TABLES FOR TGW PEERs
##########################################################################

# ###  REGION 1 ###
module "tgw_rtb_tgw_peer_region1_to_region2" {
  source = "./modules/tgw_route_table"

  rtb_name             = "tgw_peer_region1_to_region2"
  source_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region2.id
  tgw_id               = module.tgw_nonprod_region1.ec2_transit_gateway_id

  routes = {
    "local_region" = {
      cidr_block           = local.region1_pool
      target_attachment_id = module.vpc_inspection_region1.tgw_attachment_id
    }
    "peer_region" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region2.id
    }
  }

  providers = {
    aws = aws.region1
  }

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.region2_to_region1
  ]
}

# ### REGION 2 ###
module "tgw_rtb_tgw_peer_region2_to_region1" {
  source = "./modules/tgw_route_table"

  rtb_name             = "tgw_peer_region2_to_region1"
  source_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region2.id
  tgw_id               = module.tgw_nonprod_region2.ec2_transit_gateway_id

  routes = {
    "local_region" = {
      cidr_block           = local.region2_pool
      target_attachment_id = module.vpc_inspection_region2.tgw_attachment_id
    }
    "peer_region" = {
      cidr_block           = "0.0.0.0/0"
      target_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region2.id
    }
  }

  providers = {
    aws = aws.region2
  }

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.region2_to_region1
  ]
}
