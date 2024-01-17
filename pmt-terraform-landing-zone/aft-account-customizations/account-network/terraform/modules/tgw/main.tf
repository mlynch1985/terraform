# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_ec2_transit_gateway" "this" {
  amazon_side_asn                 = var.amazon_side_asn
  default_route_table_association = "enable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = "enable"
  multicast_support               = "disable"
  vpn_ecmp_support                = "disable"
  dns_support                     = "enable"

  tags = {
    Name = var.name
  }
}

resource "aws_ram_resource_share" "this" {
  name                      = var.ram_name
  allow_external_principals = false

  tags = {
    Name = var.ram_name
  }
}

resource "aws_ram_resource_association" "this" {
  resource_arn       = aws_ec2_transit_gateway.this.arn
  resource_share_arn = aws_ram_resource_share.this.id
}

resource "aws_ram_principal_association" "this" {
  count = length(var.ram_principals)

  principal          = var.ram_principals[count.index]
  resource_share_arn = aws_ram_resource_share.this.arn
}
