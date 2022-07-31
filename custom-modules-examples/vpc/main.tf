locals {
  az_index = ["a", "b", "c", "d", "e", "f"]
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block != "" && var.ipam_pool_id == "" ? var.cidr_block : null        ## Manually define CIDR
  ipv4_ipam_pool_id    = var.cidr_block == "" && var.ipam_pool_id != "" ? var.ipam_pool_id : null      ## Leverage IPAM to define CIDR
  ipv4_netmask_length  = var.cidr_block == "" && var.ipam_pool_id != "" ? var.ipam_pool_netmask : null ## Leverage IPAM to define CIDR
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    "Name" = "${var.namespace}_${var.environment}_${var.vpc_type}"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.namespace}_${var.environment}_${var.vpc_type}_default"
  }
}

resource "aws_internet_gateway" "igw" {
  count = var.vpc_type == "hub" ? 1 : 0 // Create IGW only if this is a HUB VPC

  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.namespace}_${var.environment}_igw",
    "tier" = "public"
  }
}

resource "aws_subnet" "public" {
  #checkov:skip=CKV_AWS_130:We are intentionally making these Public Subnets to be used only by our Central HUB VPC
  count = var.vpc_type == "hub" ? var.target_az_count : 0 // Create Public Subnets only if this is a HUB VPC

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, var.subnet_size_offset, count.index + var.target_az_count)
  availability_zone       = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.namespace}_${var.environment}_public_${local.az_index[count.index]}",
    "tier" = "public"
  }
}

resource "aws_route_table" "public" {
  count = var.vpc_type == "hub" ? 1 : 0 // Create a Public Route Table only if this is a HUB VPC

  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.namespace}_${var.environment}_public",
    "tier" = "public"
  }
}

resource "aws_route" "public_default" {
  count = var.vpc_type == "hub" ? 1 : 0 // Create a Public Default Route only if this is a HUB VPC

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
}

resource "aws_route_table_association" "public" {
  count = var.vpc_type == "hub" ? var.target_az_count : 0 // Create RTB Associations for our Public Subnets only if this is a HUB VPC

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_subnet" "private" {
  count = var.target_az_count

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, var.subnet_size_offset, count.index)
  availability_zone       = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.namespace}_${var.environment}_private_${local.az_index[count.index]}",
    "tier" = "private"
  }
}

resource "aws_eip" "private" {
  #checkov:skip=CKV2_AWS_19:We are intentionally not assigning these to EC2 Instances but rather NAT Gateways as part of this demo
  count = var.vpc_type == "hub" ? var.target_az_count : 0 // Create EIPs for our NAT GWs only if this is a HUB VPC

  tags = {
    "Name" = "${var.namespace}_${var.environment}_${local.az_index[count.index]}",
    "tier" = "private"
  }
}

resource "aws_nat_gateway" "private" {
  count = var.vpc_type == "hub" ? var.target_az_count : 0 // Create NAT GWs only if this is a HUB VPC

  allocation_id = aws_eip.private[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    "Name" = "${var.namespace}_${var.environment}_${local.az_index[count.index]}",
    "tier" = "private"
  }
}

resource "aws_route_table" "private" {
  count = var.vpc_type == "hub" ? var.target_az_count : 1 // Provision multiple private route tables to connect to each NAT GW otherwise use a single common one

  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.namespace}_${var.environment}_private_${local.az_index[count.index]}",
    "tier" = "private"
  }
}

resource "aws_route" "private_default_ngw" {
  count = var.vpc_type == "hub" ? var.target_az_count : 0 // Create Private Default Routes to NAT GWs only if this is a HUB VPC

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private[count.index].id
  nat_gateway_id         = aws_nat_gateway.private[count.index].id
}

resource "aws_route" "private_default_tgw" {
  count = var.vpc_type != "hub" && var.tgw_id != "" ? 1 : 0 // Create Private Default Route to TGW only if this is a SPOKE VPC and tgw_id has been specified

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private[0].id
  transit_gateway_id     = var.tgw_id
}

resource "aws_route_table_association" "private" {
  count = var.target_az_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = var.vpc_type == "hub" ? aws_route_table.private[count.index].id : aws_route_table.private[0].id // Connect each Private subnet to our Private Route Tables
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  count = var.vpc_type != "hub" && var.tgw_id != "" ? 1 : 0 // Only create a VPC to TGW Attachment if this is a Spoke VPC and a tgw_id has been provided

  subnet_ids         = aws_subnet.private[*].id
  transit_gateway_id = var.tgw_id
  vpc_id             = aws_vpc.vpc.id
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "log_group" {
  #checkov:skip=CKV_AWS_158:We do not want to enable KMS CMK for this log group as part of the demo
  count = var.enable_flow_logs ? 1 : 0 // Create CW Log Group only if VPC Flow Logs have been enabled

  name              = "/${var.namespace}/${var.environment}/vpc/flow_logs"
  retention_in_days = 30

  tags = {
    "Name" = "/${var.namespace}/${var.environment}/vpc/flow_logs"
  }
}

data "aws_iam_policy_document" "assume_role_policy_document" {
  count = var.enable_flow_logs ? 1 : 0 // Create Trust Policy only if VPC Flow Logs have been enabled

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_role" {
  count = var.enable_flow_logs ? 1 : 0 // Create IAM Role only if VPC Flow Logs have been enabled

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_document[0].json
  name_prefix        = "${var.namespace}_${var.environment}_vpc_flow_logs_"

  tags = {
    "Name" = "${var.namespace}_${var.environment}_vpc_flow_logs"
  }
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "iam_role_policy" {
  count = var.enable_flow_logs ? 1 : 0 // Create IAM Policy only if VPC Flow Logs have been enabled

  name = "GrantCloudwatchLogs"
  role = aws_iam_role.iam_role[0].name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/${var.namespace}/${var.environment}/vpc/flow_logs",
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/${var.namespace}/${var.environment}/vpc/flow_logs:*"
        ]
      }
    ]
  })
}

resource "aws_flow_log" "flow_log" {
  count = var.enable_flow_logs ? 1 : 0

  traffic_type    = "ALL"
  iam_role_arn    = aws_iam_role.iam_role[0].arn
  log_destination = aws_cloudwatch_log_group.log_group[0].arn
  vpc_id          = aws_vpc.vpc.id

  tags = {
    "Name" = "/${var.namespace}/${var.environment}/vpc/flow_logs"
  }

  depends_on = [
    aws_cloudwatch_log_group.log_group
  ]
}
