resource "aws_ec2_transit_gateway" "this" {
  default_route_table_association = var.enable_default_route_table_association ? "enable" : "disable"
  default_route_table_propagation = var.enable_default_route_table_propagation ? "enable" : "disable"
  auto_accept_shared_attachments  = var.enable_auto_accept_shared_attachments ? "enable" : "disable"
  multicast_support               = var.enable_mutlicast_support ? "enable" : "disable"
  vpn_ecmp_support                = var.enable_vpn_ecmp_support ? "enable" : "disable"
  dns_support                     = var.enable_dns_support ? "enable" : "disable"

  tags = {
    Name = var.name
  }
}

resource "aws_ram_resource_share" "this" {
  count = var.ram_name != "" ? 1 : 0

  name                      = var.ram_name
  allow_external_principals = var.ram_allow_external_principals

  tags = {
    Name = var.ram_name
  }
}

resource "aws_ram_resource_association" "this" {
  count = var.ram_name != "" ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.this.arn
  resource_share_arn = aws_ram_resource_share.this[0].id
}

resource "aws_ram_principal_association" "this" {
  count = length(var.ram_principals) > 0 ? length(var.ram_principals) : 0

  principal          = var.ram_principals[count.index]
  resource_share_arn = aws_ram_resource_share.this[0].arn
}
