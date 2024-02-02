# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  global_vars = yamldecode(file(abspath("../../${path.module}/global_vars.yaml")))

  network_account_id = [
    for account in data.aws_organizations_organization.current.accounts : account.id
    if account.name == local.global_vars.network_account_name
  ][0]
}

data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "current" {
  provider = aws.ct-management
}

data "aws_organizations_resource_tags" "current" {
  resource_id = data.aws_caller_identity.current.account_id
  provider    = aws.ct-management
}

data "aws_availability_zones" "region1" {
  state    = "available"
  provider = aws.region1
}

data "aws_availability_zones" "region2" {
  state    = "available"
  provider = aws.region2
}

data "aws_availability_zones" "region3" {
  state    = "available"
  provider = aws.region3
}

data "aws_vpc_ipam_pool" "region1" {
  filter {
    name   = "locale"
    values = [local.global_vars.region1]
  }
}

data "aws_vpc_ipam_pool" "region2" {
  filter {
    name   = "locale"
    values = [local.global_vars.region2]
  }
}

data "aws_vpc_ipam_pool" "region3" {
  filter {
    name   = "locale"
    values = [local.global_vars.region3]
  }
}

data "aws_ec2_transit_gateway" "region1" {
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "owner-id"
    values = [local.network_account_id]
  }
  provider = aws.region1
}

data "aws_ec2_transit_gateway" "region2" {
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "owner-id"
    values = [local.network_account_id]
  }
  provider = aws.region2
}

data "aws_ec2_transit_gateway" "region3" {
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "owner-id"
    values = [local.network_account_id]
  }
  provider = aws.region3
}

data "aws_ec2_transit_gateway_route_table" "default_region1" {
  filter {
    name   = "transit-gateway-id"
    values = [data.aws_ec2_transit_gateway.region1.id]
  }
  filter {
    name   = "tag:Type"
    values = ["Default"]
  }
  filter {
    name   = "tag:Domain"
    values = ["dev"]
  }

  provider = aws.network-region1
}

data "aws_ec2_transit_gateway_route_table" "default_region2" {
  filter {
    name   = "transit-gateway-id"
    values = [data.aws_ec2_transit_gateway.region2.id]
  }
  filter {
    name   = "tag:Type"
    values = ["Default"]
  }
  filter {
    name   = "tag:Domain"
    values = ["dev"]
  }

  provider = aws.network-region2
}

data "aws_ec2_transit_gateway_route_table" "default_region3" {
  filter {
    name   = "transit-gateway-id"
    values = [data.aws_ec2_transit_gateway.region3.id]
  }
  filter {
    name   = "tag:Type"
    values = ["Default"]
  }
  filter {
    name   = "tag:Domain"
    values = ["dev"]
  }

  provider = aws.network-region3
}

data "aws_ec2_transit_gateway_route_table" "inspection_region1" {
  filter {
    name   = "transit-gateway-id"
    values = [data.aws_ec2_transit_gateway.region1.id]
  }
  filter {
    name   = "tag:Type"
    values = ["Inspection"]
  }
  filter {
    name   = "tag:Domain"
    values = ["dev"]
  }

  provider = aws.network-region1
}

data "aws_ec2_transit_gateway_route_table" "inspection_region2" {
  filter {
    name   = "transit-gateway-id"
    values = [data.aws_ec2_transit_gateway.region2.id]
  }
  filter {
    name   = "tag:Type"
    values = ["Inspection"]
  }
  filter {
    name   = "tag:Domain"
    values = ["dev"]
  }

  provider = aws.network-region2
}

data "aws_ec2_transit_gateway_route_table" "inspection_region3" {
  filter {
    name   = "transit-gateway-id"
    values = [data.aws_ec2_transit_gateway.region3.id]
  }
  filter {
    name   = "tag:Type"
    values = ["Inspection"]
  }
  filter {
    name   = "tag:Domain"
    values = ["dev"]
  }

  provider = aws.network-region3
}
