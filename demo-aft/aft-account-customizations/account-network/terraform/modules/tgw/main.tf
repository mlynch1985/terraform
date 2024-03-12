# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_ec2_transit_gateway" "this" {
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  multicast_support               = "disable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name   = var.name
    Domain = var.domain
  }

  provisioner "local-exec" {
    on_failure = continue
    command    = "aws ec2 create-tags --resources ${aws_ec2_transit_gateway.this.association_default_route_table_id} --tags Key=Name,Value=${var.name} Key=Domain,Value=${var.domain} --region ${data.aws_region.current.name}"
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
