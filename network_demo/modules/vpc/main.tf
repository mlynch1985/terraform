resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = var.name
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = length(var.secondary_cidr_blocks) > 0 ? length(var.secondary_cidr_blocks) : 0

  vpc_id     = aws_vpc.this.id
  cidr_block = element(var.secondary_cidr_blocks, count.index)
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-default"
  }
}

resource "aws_internet_gateway" "this" {
  count = var.enable_internet_gateway && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.name
  }
}

resource "aws_route_table" "public" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}_public"
  }
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id = aws_vpc.this.id

  tags = {
    Name = element(concat(var.private_subnet_names, [""]), count.index)
  }
}

resource "aws_route_table" "transit" {
  count = length(var.transit_subnets) > 0 ? length(var.transit_subnets) : 0

  vpc_id = aws_vpc.this.id

  tags = {
    Name = element(concat(var.transit_subnet_names, [""]), count.index)
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc_id               = aws_vpc.this.id
  cidr_block           = element(concat(var.public_subnets, [""]), count.index)
  availability_zone_id = element(concat(var.azs, [""]), count.index)

  tags = {
    Name = element(concat(var.public_subnet_names, [""]), count.index)
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id               = aws_vpc.this.id
  cidr_block           = element(concat(var.private_subnets, [""]), count.index)
  availability_zone_id = element(concat(var.azs, [""]), count.index)

  tags = {
    Name = element(concat(var.private_subnet_names, [""]), count.index)
  }
}

resource "aws_subnet" "transit" {
  count = length(var.transit_subnets) > 0 ? length(var.transit_subnets) : 0

  vpc_id               = aws_vpc.this.id
  cidr_block           = element(concat(var.transit_subnets, [""]), count.index)
  availability_zone_id = element(concat(var.azs, [""]), count.index)

  tags = {
    Name = element(concat(var.transit_subnet_names, [""]), count.index)
  }
}

resource "aws_eip" "this" {
  count = var.enable_nat_gateway && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc = true
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  allocation_id = element(aws_eip.this[*].id, count.index)
  subnet_id     = element(aws_subnet.public[*].id, count.index)

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route" "internet_gateway" {
  count = var.enable_internet_gateway && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route" "private_nat" {
  count = var.enable_nat_gateway && length(var.public_subnets) > 0 && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)
}

resource "aws_route" "transit_nat" {
  count = var.enable_nat_gateway && length(var.public_subnets) > 0 && length(var.transit_subnets) > 0 ? length(var.transit_subnets) : 0

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
  count = length(local.endpoints)

  route_table_id         = element(aws_route_table.transit[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = element(local.endpoints[*].endpoint_id, count.index)
}

resource "aws_route" "public_tgw" {
  count = var.tgw_id != "" && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = element(aws_route_table.public[*].id, count.index)
  destination_cidr_block = var.tgw_cidr_route
  transit_gateway_id     = var.tgw_id
}

resource "aws_route" "private_tgw" {
  count = var.tgw_id != "" && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = var.tgw_cidr_route
  transit_gateway_id     = var.tgw_id
}

resource "aws_route" "transit_tgw" {
  count = length(local.endpoints) == 0 && var.tgw_id != "" && length(var.transit_subnets) > 0 ? length(var.transit_subnets) : 0

  route_table_id         = element(aws_route_table.transit[*].id, count.index)
  destination_cidr_block = var.tgw_cidr_route
  transit_gateway_id     = var.tgw_id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = element(aws_route_table.public[*].id, count.index)
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

resource "aws_route_table_association" "transit" {
  count = length(var.transit_subnets) > 0 ? length(var.transit_subnets) : 0

  subnet_id      = element(aws_subnet.transit[*].id, count.index)
  route_table_id = element(aws_route_table.transit[*].id, count.index)
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  count = var.tgw_id != "" ? 1 : 0

  subnet_ids             = aws_subnet.transit[*].id
  transit_gateway_id     = var.tgw_id
  vpc_id                 = aws_vpc.this.id
  appliance_mode_support = var.appliance_mode_support

  tags = {
    Name = var.name
  }

  lifecycle {
    ignore_changes = [
      transit_gateway_default_route_table_association,
      transit_gateway_default_route_table_propagation
    ]
  }
}

resource "aws_networkfirewall_firewall_policy" "this" {
  count = var.enable_firewall && length(var.private_subnets) > 0 ? 1 : 0

  name = var.name

  firewall_policy {
    stateless_default_actions          = ["aws:pass"]
    stateless_fragment_default_actions = ["aws:drop"]
  }

  tags = {
    Name = var.name
  }
}

resource "aws_networkfirewall_firewall" "this" {
  count = var.enable_firewall && length(var.private_subnets) > 0 ? 1 : 0

  name                = var.name
  firewall_policy_arn = aws_networkfirewall_firewall_policy.this[0].arn
  vpc_id              = aws_vpc.this.id

  dynamic "subnet_mapping" {
    for_each = aws_subnet.private

    content {
      subnet_id = subnet_mapping.value.id
    }
  }

  tags = {
    Name = var.name
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/vpc/flowlogs/${var.name}"
  retention_in_days = 30
}

resource "aws_iam_role" "this" {
  name_prefix = "vpc_flow_logs_${var.name}_"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "CloudWatch_Logs"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }

  depends_on = [aws_cloudwatch_log_group.this]
}

resource "aws_flow_log" "this" {
  traffic_type             = "ALL"
  iam_role_arn             = aws_iam_role.this.arn
  log_destination          = aws_cloudwatch_log_group.this.arn
  vpc_id                   = aws_vpc.this.id
  max_aggregation_interval = 60
}
