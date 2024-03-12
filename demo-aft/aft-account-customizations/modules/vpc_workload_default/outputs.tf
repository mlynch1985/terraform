# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = aws_vpc.this.default_network_acl_id
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = aws_vpc.this.default_route_table_id
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.this.default_security_group_id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = { for key, value in aws_route_table.private : key => value.id }
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = { for key, value in aws_subnet.private : key => value.id }
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = { for key, value in aws_subnet.private : key => value.arn }
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = { for key, value in aws_subnet.private : key => value.cidr_block }
}

output "transit_route_table_ids" {
  description = "List of IDs of transit route tables"
  value       = { for key, value in aws_route_table.transit : key => value.id }
}

output "transit_subnets" {
  description = "List of IDs of transit subnets"
  value       = { for key, value in aws_subnet.transit : key => value.id }
}

output "transit_subnet_arns" {
  description = "List of ARNs of transit subnets"
  value       = { for key, value in aws_subnet.transit : key => value.arn }
}

output "transit_subnets_cidr_blocks" {
  description = "List of cidr_blocks of transit subnets"
  value       = { for key, value in aws_subnet.transit : key => value.cidr_block }
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = aws_vpc.this.main_route_table_id
}

output "tgw_attachment_id" {
  description = "The Transit Gateway Attachment ID"
  value       = aws_ec2_transit_gateway_vpc_attachment.this.id
}

output "cloudwatch_log_group_name" {
  description = "The name of the VPC Flow Logs Log Group"
  value       = aws_cloudwatch_log_group.this.name
}
