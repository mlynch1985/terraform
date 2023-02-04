resource "aws_route_table" "public" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}_public"
  }
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets)

  vpc_id = aws_vpc.this.id

  tags = {
    Name = element(concat(var.private_subnet_names, [""]), count.index)
  }
}

resource "aws_route_table" "transit" {
  count = length(var.transit_subnets)

  vpc_id = aws_vpc.this.id

  tags = {
    Name = element(concat(var.transit_subnet_names, [""]), count.index)
  }
}

resource "aws_route" "internet_gateway" {
  count = var.enable_internet_gateway && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route" "private_nat" {
  count = var.enable_nat_gateway && length(var.public_subnets) > 0 ? length(var.private_subnets) : 0

  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)
}

resource "aws_route" "transit_nat" {
  count = var.enable_nat_gateway && length(var.public_subnets) > 0 ? length(var.transit_subnets) : 0

  route_table_id         = element(aws_route_table.transit[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)
}

locals {
  endpoints = flatten([
    for fw in aws_networkfirewall_firewall.this : [
      for fw_status in fw.firewall_status : [
        for sync_state in fw_status.sync_states : sync_state.attachment
      ]
    ]
  ])
}

resource "aws_route" "transit_fw" {
  count = var.enable_firewall ? length(var.private_subnets) : 0

  route_table_id         = element(aws_route_table.transit[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = element(local.endpoints[*].endpoint_id, count.index)

  depends_on = [aws_networkfirewall_firewall.this]
}

resource "aws_route" "public_tgw" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = element(aws_route_table.public[*].id, count.index)
  destination_cidr_block = var.tgw_cidr_route
  transit_gateway_id     = var.tgw_id

  depends_on = [aws_route_table_association.public]
}

resource "aws_route" "private_tgw" {
  count = length(var.private_subnets)

  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = var.tgw_cidr_route
  transit_gateway_id     = var.tgw_id

  depends_on = [aws_route_table_association.private]
}

resource "aws_route" "transit_tgw" {
  count = var.enable_firewall == false ? length(var.transit_subnets) : 0

  route_table_id         = element(aws_route_table.transit[*].id, count.index)
  destination_cidr_block = var.tgw_cidr_route
  transit_gateway_id     = var.tgw_id

  depends_on = [aws_route_table_association.transit]
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = element(aws_route_table.public[*].id, count.index)
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

resource "aws_route_table_association" "transit" {
  count = length(var.transit_subnets)

  subnet_id      = element(aws_subnet.transit[*].id, count.index)
  route_table_id = element(aws_route_table.transit[*].id, count.index)
}
