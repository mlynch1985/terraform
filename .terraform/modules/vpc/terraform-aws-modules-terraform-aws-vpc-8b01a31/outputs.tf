output "vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.this.*.id, [""])[0]
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = concat(aws_vpc.this.*.arn, [""])[0]
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = concat(aws_vpc.this.*.cidr_block, [""])[0]
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = concat(aws_vpc.this.*.default_security_group_id, [""])[0]
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = concat(aws_vpc.this.*.default_network_acl_id, [""])[0]
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = concat(aws_vpc.this.*.default_route_table_id, [""])[0]
}

output "vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = concat(aws_vpc.this.*.instance_tenancy, [""])[0]
}

output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = concat(aws_vpc.this.*.enable_dns_support, [""])[0]
}

output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = concat(aws_vpc.this.*.enable_dns_hostnames, [""])[0]
}

//output "vpc_enable_classiclink" {
//  description = "Whether or not the VPC has Classiclink enabled"
//  value       = concat(aws_vpc.this.*.enable_classiclink, [""])[0]
//}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = concat(aws_vpc.this.*.main_route_table_id, [""])[0]
}

output "vpc_ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block"
  value       = concat(aws_vpc.this.*.ipv6_association_id, [""])[0]
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = concat(aws_vpc.this.*.ipv6_cidr_block, [""])[0]
}

output "vpc_secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks of the VPC"
  value       = aws_vpc_ipv4_cidr_block_association.this.*.cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.private.*.arn
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.private.*.cidr_block
}

output "private_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of private subnets in an IPv6 enabled VPC"
  value       = aws_subnet.private.*.ipv6_cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public.*.id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public.*.arn
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = aws_subnet.public.*.cidr_block
}

output "public_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC"
  value       = aws_subnet.public.*.ipv6_cidr_block
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = aws_subnet.database.*.id
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = aws_subnet.database.*.arn
}

output "database_subnets_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = aws_subnet.database.*.cidr_block
}

output "database_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of database subnets in an IPv6 enabled VPC"
  value       = aws_subnet.database.*.ipv6_cidr_block
}

output "database_subnet_group" {
  description = "ID of database subnet group"
  value       = concat(aws_db_subnet_group.database.*.id, [""])[0]
}

output "redshift_subnets" {
  description = "List of IDs of redshift subnets"
  value       = aws_subnet.redshift.*.id
}

output "redshift_subnet_arns" {
  description = "List of ARNs of redshift subnets"
  value       = aws_subnet.redshift.*.arn
}

output "redshift_subnets_cidr_blocks" {
  description = "List of cidr_blocks of redshift subnets"
  value       = aws_subnet.redshift.*.cidr_block
}

output "redshift_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of redshift subnets in an IPv6 enabled VPC"
  value       = aws_subnet.redshift.*.ipv6_cidr_block
}

output "redshift_subnet_group" {
  description = "ID of redshift subnet group"
  value       = concat(aws_redshift_subnet_group.redshift.*.id, [""])[0]
}

output "elasticache_subnets" {
  description = "List of IDs of elasticache subnets"
  value       = aws_subnet.elasticache.*.id
}

output "elasticache_subnet_arns" {
  description = "List of ARNs of elasticache subnets"
  value       = aws_subnet.elasticache.*.arn
}

output "elasticache_subnets_cidr_blocks" {
  description = "List of cidr_blocks of elasticache subnets"
  value       = aws_subnet.elasticache.*.cidr_block
}

output "elasticache_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of elasticache subnets in an IPv6 enabled VPC"
  value       = aws_subnet.elasticache.*.ipv6_cidr_block
}

output "intra_subnets" {
  description = "List of IDs of intra subnets"
  value       = aws_subnet.intra.*.id
}

output "intra_subnet_arns" {
  description = "List of ARNs of intra subnets"
  value       = aws_subnet.intra.*.arn
}

output "intra_subnets_cidr_blocks" {
  description = "List of cidr_blocks of intra subnets"
  value       = aws_subnet.intra.*.cidr_block
}

output "intra_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of intra subnets in an IPv6 enabled VPC"
  value       = aws_subnet.intra.*.ipv6_cidr_block
}

output "elasticache_subnet_group" {
  description = "ID of elasticache subnet group"
  value       = concat(aws_elasticache_subnet_group.elasticache.*.id, [""])[0]
}

output "elasticache_subnet_group_name" {
  description = "Name of elasticache subnet group"
  value       = concat(aws_elasticache_subnet_group.elasticache.*.name, [""])[0]
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = aws_route_table.public.*.id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = aws_route_table.private.*.id
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = length(aws_route_table.database.*.id) > 0 ? aws_route_table.database.*.id : aws_route_table.private.*.id
}

output "redshift_route_table_ids" {
  description = "List of IDs of redshift route tables"
  value       = length(aws_route_table.redshift.*.id) > 0 ? aws_route_table.redshift.*.id : aws_route_table.private.*.id
}

output "elasticache_route_table_ids" {
  description = "List of IDs of elasticache route tables"
  value       = length(aws_route_table.elasticache.*.id) > 0 ? aws_route_table.elasticache.*.id : aws_route_table.private.*.id
}

output "intra_route_table_ids" {
  description = "List of IDs of intra route tables"
  value       = aws_route_table.intra.*.id
}

output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.nat.*.id
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.nat.*.public_ip
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this.*.id
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = concat(aws_internet_gateway.this.*.id, [""])[0]
}

output "egress_only_internet_gateway_id" {
  description = "The ID of the egress only Internet Gateway"
  value       = concat(aws_egress_only_internet_gateway.this.*.id, [""])[0]
}

output "cgw_ids" {
  description = "List of IDs of Customer Gateway"
  value       = [for k, v in aws_customer_gateway.this : v.id]
}

output "this_customer_gateway" {
  description = "Map of Customer Gateway attributes"
  value       = aws_customer_gateway.this
}

output "vgw_id" {
  description = "The ID of the VPN Gateway"
  value = concat(
    aws_vpn_gateway.this.*.id,
    aws_vpn_gateway_attachment.this.*.vpn_gateway_id,
    [""],
  )[0]
}

output "default_vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_default_vpc.this.*.id, [""])[0]
}

output "default_vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = concat(aws_default_vpc.this.*.cidr_block, [""])[0]
}

output "default_vpc_default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = concat(aws_default_vpc.this.*.default_security_group_id, [""])[0]
}

output "default_vpc_default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = concat(aws_default_vpc.this.*.default_network_acl_id, [""])[0]
}

output "default_vpc_default_route_table_id" {
  description = "The ID of the default route table"
  value       = concat(aws_default_vpc.this.*.default_route_table_id, [""])[0]
}

output "default_vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = concat(aws_default_vpc.this.*.instance_tenancy, [""])[0]
}

output "default_vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = concat(aws_default_vpc.this.*.enable_dns_support, [""])[0]
}

output "default_vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = concat(aws_default_vpc.this.*.enable_dns_hostnames, [""])[0]
}

//output "default_vpc_enable_classiclink" {
//  description = "Whether or not the VPC has Classiclink enabled"
//  value       = concat(aws_default_vpc.this.*.enable_classiclink, [""])[0]
//}

output "default_vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = concat(aws_default_vpc.this.*.main_route_table_id, [""])[0]
}

//output "default_vpc_ipv6_association_id" {
//  description = "The association ID for the IPv6 CIDR block"
//  value       = concat(aws_default_vpc.this.*.ipv6_association_id, [""])[0]
//}
//
//output "default_vpc_ipv6_cidr_block" {
//  description = "The IPv6 CIDR block"
//  value       = concat(aws_default_vpc.this.*.ipv6_cidr_block, [""])[0]
//}

output "public_network_acl_id" {
  description = "ID of the public network ACL"
  value       = concat(aws_network_acl.public.*.id, [""])[0]
}

output "private_network_acl_id" {
  description = "ID of the private network ACL"
  value       = concat(aws_network_acl.private.*.id, [""])[0]
}

output "intra_network_acl_id" {
  description = "ID of the intra network ACL"
  value       = concat(aws_network_acl.intra.*.id, [""])[0]
}

output "database_network_acl_id" {
  description = "ID of the database network ACL"
  value       = concat(aws_network_acl.database.*.id, [""])[0]
}

output "redshift_network_acl_id" {
  description = "ID of the redshift network ACL"
  value       = concat(aws_network_acl.redshift.*.id, [""])[0]
}

output "elasticache_network_acl_id" {
  description = "ID of the elasticache network ACL"
  value       = concat(aws_network_acl.elasticache.*.id, [""])[0]
}

# VPC Endpoints
output "vpc_endpoint_s3_id" {
  description = "The ID of VPC endpoint for S3"
  value       = concat(aws_vpc_endpoint.s3.*.id, [""])[0]
}

output "vpc_endpoint_s3_pl_id" {
  description = "The prefix list for the S3 VPC endpoint."
  value       = concat(aws_vpc_endpoint.s3.*.prefix_list_id, [""])[0]
}

output "vpc_endpoint_dynamodb_id" {
  description = "The ID of VPC endpoint for DynamoDB"
  value       = concat(aws_vpc_endpoint.dynamodb.*.id, [""])[0]
}

output "vpc_endpoint_dynamodb_pl_id" {
  description = "The prefix list for the DynamoDB VPC endpoint."
  value       = concat(aws_vpc_endpoint.dynamodb.*.prefix_list_id, [""])[0]
}

output "vpc_endpoint_sqs_id" {
  description = "The ID of VPC endpoint for SQS"
  value       = concat(aws_vpc_endpoint.sqs.*.id, [""])[0]
}

output "vpc_endpoint_sqs_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for SQS."
  value       = flatten(aws_vpc_endpoint.sqs.*.network_interface_ids)
}

output "vpc_endpoint_sqs_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for SQS."
  value       = flatten(aws_vpc_endpoint.sqs.*.dns_entry)
}

output "vpc_endpoint_codebuild_id" {
  description = "The ID of VPC endpoint for codebuild"
  value       = concat(aws_vpc_endpoint.codebuild.*.id, [""])[0]
}

output "vpc_endpoint_codebuild_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for codebuild."
  value       = flatten(aws_vpc_endpoint.codebuild.*.network_interface_ids)
}

output "vpc_endpoint_codebuild_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for codebuild."
  value       = flatten(aws_vpc_endpoint.codebuild.*.dns_entry)
}

output "vpc_endpoint_codecommit_id" {
  description = "The ID of VPC endpoint for codecommit"
  value       = concat(aws_vpc_endpoint.codecommit.*.id, [""])[0]
}

output "vpc_endpoint_codecommit_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for codecommit."
  value       = flatten(aws_vpc_endpoint.codecommit.*.network_interface_ids)
}

output "vpc_endpoint_codecommit_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for codecommit."
  value       = flatten(aws_vpc_endpoint.codecommit.*.dns_entry)
}

output "vpc_endpoint_git_codecommit_id" {
  description = "The ID of VPC endpoint for git_codecommit"
  value       = concat(aws_vpc_endpoint.git_codecommit.*.id, [""])[0]
}

output "vpc_endpoint_git_codecommit_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for git_codecommit."
  value       = flatten(aws_vpc_endpoint.git_codecommit.*.network_interface_ids)
}

output "vpc_endpoint_git_codecommit_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for git_codecommit."
  value       = flatten(aws_vpc_endpoint.git_codecommit.*.dns_entry)
}

output "vpc_endpoint_config_id" {
  description = "The ID of VPC endpoint for config"
  value       = concat(aws_vpc_endpoint.config.*.id, [""])[0]
}

output "vpc_endpoint_config_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for config."
  value       = flatten(aws_vpc_endpoint.config.*.network_interface_ids)
}

output "vpc_endpoint_config_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for config."
  value       = flatten(aws_vpc_endpoint.config.*.dns_entry)
}

output "vpc_endpoint_secretsmanager_id" {
  description = "The ID of VPC endpoint for secretsmanager"
  value       = concat(aws_vpc_endpoint.secretsmanager.*.id, [""])[0]
}

output "vpc_endpoint_secretsmanager_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for secretsmanager."
  value       = flatten(aws_vpc_endpoint.secretsmanager.*.network_interface_ids)
}

output "vpc_endpoint_secretsmanager_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for secretsmanager."
  value       = flatten(aws_vpc_endpoint.secretsmanager.*.dns_entry)
}

output "vpc_endpoint_ssm_id" {
  description = "The ID of VPC endpoint for SSM"
  value       = concat(aws_vpc_endpoint.ssm.*.id, [""])[0]
}

output "vpc_endpoint_ssm_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for SSM."
  value       = flatten(aws_vpc_endpoint.ssm.*.network_interface_ids)
}

output "vpc_endpoint_ssm_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for SSM."
  value       = flatten(aws_vpc_endpoint.ssm.*.dns_entry)
}

output "vpc_endpoint_ssmmessages_id" {
  description = "The ID of VPC endpoint for SSMMESSAGES"
  value       = concat(aws_vpc_endpoint.ssmmessages.*.id, [""])[0]
}

output "vpc_endpoint_ssmmessages_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for SSMMESSAGES."
  value       = flatten(aws_vpc_endpoint.ssmmessages.*.network_interface_ids)
}

output "vpc_endpoint_ssmmessages_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for SSMMESSAGES."
  value       = flatten(aws_vpc_endpoint.ssmmessages.*.dns_entry)
}

output "vpc_endpoint_ec2_id" {
  description = "The ID of VPC endpoint for EC2"
  value       = concat(aws_vpc_endpoint.ec2.*.id, [""])[0]
}

output "vpc_endpoint_ec2_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for EC2"
  value       = flatten(aws_vpc_endpoint.ec2.*.network_interface_ids)
}

output "vpc_endpoint_ec2_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for EC2."
  value       = flatten(aws_vpc_endpoint.ec2.*.dns_entry)
}

output "vpc_endpoint_ec2messages_id" {
  description = "The ID of VPC endpoint for EC2MESSAGES"
  value       = concat(aws_vpc_endpoint.ec2messages.*.id, [""])[0]
}

output "vpc_endpoint_ec2messages_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for EC2MESSAGES"
  value       = flatten(aws_vpc_endpoint.ec2messages.*.network_interface_ids)
}

output "vpc_endpoint_ec2messages_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for EC2MESSAGES."
  value       = flatten(aws_vpc_endpoint.ec2messages.*.dns_entry)
}

output "vpc_endpoint_transferserver_id" {
  description = "The ID of VPC endpoint for transferserver"
  value       = concat(aws_vpc_endpoint.transferserver.*.id, [""])[0]
}

output "vpc_endpoint_transferserver_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for transferserver"
  value       = flatten(aws_vpc_endpoint.transferserver.*.network_interface_ids)
}

output "vpc_endpoint_transferserver_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for transferserver."
  value       = flatten(aws_vpc_endpoint.transferserver.*.dns_entry)
}

output "vpc_endpoint_glue_id" {
  description = "The ID of VPC endpoint for Glue"
  value       = concat(aws_vpc_endpoint.glue.*.id, [""])[0]
}

output "vpc_endpoint_glue_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for Glue."
  value       = flatten(aws_vpc_endpoint.glue.*.network_interface_ids)
}

output "vpc_endpoint_glue_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for Glue."
  value       = flatten(aws_vpc_endpoint.glue.*.dns_entry)
}

output "vpc_endpoint_kms_id" {
  description = "The ID of VPC endpoint for KMS"
  value       = concat(aws_vpc_endpoint.kms.*.id, [""])[0]
}

output "vpc_endpoint_kms_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for KMS."
  value       = flatten(aws_vpc_endpoint.kms.*.network_interface_ids)
}

output "vpc_endpoint_kms_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for KMS."
  value       = flatten(aws_vpc_endpoint.kms.*.dns_entry)
}

output "vpc_endpoint_kinesis_firehose_id" {
  description = "The ID of VPC endpoint for Kinesis Firehose"
  value       = concat(aws_vpc_endpoint.kinesis_firehose.*.id, [""])[0]
}

output "vpc_endpoint_kinesis_firehose_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for Kinesis Firehose."
  value       = flatten(aws_vpc_endpoint.kinesis_firehose.*.network_interface_ids)
}

output "vpc_endpoint_kinesis_firehose_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for Kinesis Firehose."
  value       = flatten(aws_vpc_endpoint.kinesis_firehose.*.dns_entry)
}

output "vpc_endpoint_kinesis_streams_id" {
  description = "The ID of VPC endpoint for Kinesis Streams"
  value       = concat(aws_vpc_endpoint.kinesis_streams.*.id, [""])[0]
}

output "vpc_endpoint_kinesis_streams_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for Kinesis Streams."
  value       = flatten(aws_vpc_endpoint.kinesis_streams.*.network_interface_ids)
}

output "vpc_endpoint_kinesis_streams_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for Kinesis Streams."
  value       = flatten(aws_vpc_endpoint.kinesis_streams.*.dns_entry)
}

output "vpc_endpoint_ecr_api_id" {
  description = "The ID of VPC endpoint for ECR API"
  value       = concat(aws_vpc_endpoint.ecr_api.*.id, [""])[0]
}

output "vpc_endpoint_ecr_api_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for ECR API."
  value       = flatten(aws_vpc_endpoint.ecr_api.*.network_interface_ids)
}

output "vpc_endpoint_ecr_api_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for ECR API."
  value       = flatten(aws_vpc_endpoint.ecr_api.*.dns_entry)
}

output "vpc_endpoint_ecr_dkr_id" {
  description = "The ID of VPC endpoint for ECR DKR"
  value       = concat(aws_vpc_endpoint.ecr_dkr.*.id, [""])[0]
}

output "vpc_endpoint_ecr_dkr_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for ECR DKR."
  value       = flatten(aws_vpc_endpoint.ecr_dkr.*.network_interface_ids)
}

output "vpc_endpoint_ecr_dkr_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for ECR DKR."
  value       = flatten(aws_vpc_endpoint.ecr_dkr.*.dns_entry)
}

output "vpc_endpoint_apigw_id" {
  description = "The ID of VPC endpoint for APIGW"
  value       = concat(aws_vpc_endpoint.apigw.*.id, [""])[0]
}

output "vpc_endpoint_apigw_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for APIGW."
  value       = flatten(aws_vpc_endpoint.apigw.*.network_interface_ids)
}

output "vpc_endpoint_apigw_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for APIGW."
  value       = flatten(aws_vpc_endpoint.apigw.*.dns_entry)
}

output "vpc_endpoint_ecs_id" {
  description = "The ID of VPC endpoint for ECS"
  value       = concat(aws_vpc_endpoint.ecs.*.id, [""])[0]
}

output "vpc_endpoint_ecs_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for ECS."
  value       = flatten(aws_vpc_endpoint.ecs.*.network_interface_ids)
}

output "vpc_endpoint_ecs_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for ECS."
  value       = flatten(aws_vpc_endpoint.ecs.*.dns_entry)
}

output "vpc_endpoint_ecs_agent_id" {
  description = "The ID of VPC endpoint for ECS Agent"
  value       = concat(aws_vpc_endpoint.ecs_agent.*.id, [""])[0]
}

output "vpc_endpoint_ecs_agent_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for ECS Agent."
  value       = flatten(aws_vpc_endpoint.ecs_agent.*.network_interface_ids)
}

output "vpc_endpoint_ecs_agent_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for ECS Agent."
  value       = flatten(aws_vpc_endpoint.ecs_agent.*.dns_entry)
}

output "vpc_endpoint_ecs_telemetry_id" {
  description = "The ID of VPC endpoint for ECS Telemetry"
  value       = concat(aws_vpc_endpoint.ecs_telemetry.*.id, [""])[0]
}

output "vpc_endpoint_ecs_telemetry_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for ECS Telemetry."
  value       = flatten(aws_vpc_endpoint.ecs_telemetry.*.network_interface_ids)
}

output "vpc_endpoint_ecs_telemetry_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for ECS Telemetry."
  value       = flatten(aws_vpc_endpoint.ecs_telemetry.*.dns_entry)
}

output "vpc_endpoint_sns_id" {
  description = "The ID of VPC endpoint for SNS"
  value       = concat(aws_vpc_endpoint.sns.*.id, [""])[0]
}

output "vpc_endpoint_sns_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for SNS."
  value       = flatten(aws_vpc_endpoint.sns.*.network_interface_ids)
}

output "vpc_endpoint_sns_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for SNS."
  value       = flatten(aws_vpc_endpoint.sns.*.dns_entry)
}

output "vpc_endpoint_monitoring_id" {
  description = "The ID of VPC endpoint for CloudWatch Monitoring"
  value       = concat(aws_vpc_endpoint.monitoring.*.id, [""])[0]
}

output "vpc_endpoint_monitoring_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for CloudWatch Monitoring."
  value       = flatten(aws_vpc_endpoint.monitoring.*.network_interface_ids)
}

output "vpc_endpoint_monitoring_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for CloudWatch Monitoring."
  value       = flatten(aws_vpc_endpoint.monitoring.*.dns_entry)
}

output "vpc_endpoint_logs_id" {
  description = "The ID of VPC endpoint for CloudWatch Logs"
  value       = concat(aws_vpc_endpoint.logs.*.id, [""])[0]
}

output "vpc_endpoint_logs_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for CloudWatch Logs."
  value       = flatten(aws_vpc_endpoint.logs.*.network_interface_ids)
}

output "vpc_endpoint_logs_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for CloudWatch Logs."
  value       = flatten(aws_vpc_endpoint.logs.*.dns_entry)
}

output "vpc_endpoint_events_id" {
  description = "The ID of VPC endpoint for CloudWatch Events"
  value       = concat(aws_vpc_endpoint.events.*.id, [""])[0]
}

output "vpc_endpoint_events_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for CloudWatch Events."
  value       = flatten(aws_vpc_endpoint.events.*.network_interface_ids)
}

output "vpc_endpoint_events_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for CloudWatch Events."
  value       = flatten(aws_vpc_endpoint.events.*.dns_entry)
}

output "vpc_endpoint_elasticloadbalancing_id" {
  description = "The ID of VPC endpoint for Elastic Load Balancing"
  value       = concat(aws_vpc_endpoint.elasticloadbalancing.*.id, [""])[0]
}

output "vpc_endpoint_elasticloadbalancing_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for Elastic Load Balancing."
  value       = flatten(aws_vpc_endpoint.elasticloadbalancing.*.network_interface_ids)
}

output "vpc_endpoint_elasticloadbalancing_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for Elastic Load Balancing."
  value       = flatten(aws_vpc_endpoint.elasticloadbalancing.*.dns_entry)
}

output "vpc_endpoint_cloudtrail_id" {
  description = "The ID of VPC endpoint for CloudTrail"
  value       = concat(aws_vpc_endpoint.cloudtrail.*.id, [""])[0]
}

output "vpc_endpoint_cloudtrail_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for CloudTrail."
  value       = flatten(aws_vpc_endpoint.cloudtrail.*.network_interface_ids)
}

output "vpc_endpoint_cloudtrail_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for CloudTrail."
  value       = flatten(aws_vpc_endpoint.cloudtrail.*.dns_entry)
}

output "vpc_endpoint_sts_id" {
  description = "The ID of VPC endpoint for STS"
  value       = concat(aws_vpc_endpoint.sts.*.id, [""])[0]
}

output "vpc_endpoint_sts_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for STS."
  value       = flatten(aws_vpc_endpoint.sts.*.network_interface_ids)
}

output "vpc_endpoint_sts_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for STS."
  value       = flatten(aws_vpc_endpoint.sts.*.dns_entry)
}

output "vpc_endpoint_cloudformation_id" {
  description = "The ID of VPC endpoint for Cloudformation"
  value       = concat(aws_vpc_endpoint.cloudformation.*.id, [""])[0]
}

output "vpc_endpoint_cloudformation_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for Cloudformation."
  value       = flatten(aws_vpc_endpoint.cloudformation.*.network_interface_ids)
}

output "vpc_endpoint_cloudformation_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for Cloudformation."
  value       = flatten(aws_vpc_endpoint.cloudformation.*.dns_entry)
}
output "vpc_endpoint_codepipeline_id" {
  description = "The ID of VPC endpoint for CodePipeline"
  value       = concat(aws_vpc_endpoint.codepipeline.*.id, [""])[0]
}

output "vpc_endpoint_codepipeline_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for CodePipeline."
  value       = flatten(aws_vpc_endpoint.codepipeline.*.network_interface_ids)
}

output "vpc_endpoint_codepipeline_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for CodePipeline."
  value       = flatten(aws_vpc_endpoint.codepipeline.*.dns_entry)
}
output "vpc_endpoint_appmesh_envoy_management_id" {
  description = "The ID of VPC endpoint for AppMesh"
  value       = concat(aws_vpc_endpoint.appmesh_envoy_management.*.id, [""])[0]
}

output "vpc_endpoint_appmesh_envoy_management_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for AppMesh."
  value       = flatten(aws_vpc_endpoint.appmesh_envoy_management.*.network_interface_ids)
}

output "vpc_endpoint_appmesh_envoy_management_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for AppMesh."
  value       = flatten(aws_vpc_endpoint.appmesh_envoy_management.*.dns_entry)
}
output "vpc_endpoint_servicecatalog_id" {
  description = "The ID of VPC endpoint for Service Catalog"
  value       = concat(aws_vpc_endpoint.servicecatalog.*.id, [""])[0]
}

output "vpc_endpoint_servicecatalog_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for Service Catalog."
  value       = flatten(aws_vpc_endpoint.servicecatalog.*.network_interface_ids)
}

output "vpc_endpoint_servicecatalog_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for Service Catalog."
  value       = flatten(aws_vpc_endpoint.servicecatalog.*.dns_entry)
}
output "vpc_endpoint_storagegateway_id" {
  description = "The ID of VPC endpoint for Storage Gateway"
  value       = concat(aws_vpc_endpoint.storagegateway.*.id, [""])[0]
}

output "vpc_endpoint_storagegateway_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for Storage Gateway."
  value       = flatten(aws_vpc_endpoint.storagegateway.*.network_interface_ids)
}

output "vpc_endpoint_storagegateway_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for Storage Gateway."
  value       = flatten(aws_vpc_endpoint.storagegateway.*.dns_entry)
}
output "vpc_endpoint_transfer_id" {
  description = "The ID of VPC endpoint for Transfer"
  value       = concat(aws_vpc_endpoint.transfer.*.id, [""])[0]
}

output "vpc_endpoint_transfer_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for Transfer."
  value       = flatten(aws_vpc_endpoint.transfer.*.network_interface_ids)
}

output "vpc_endpoint_transfer_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for Transfer."
  value       = flatten(aws_vpc_endpoint.transfer.*.dns_entry)
}
output "vpc_endpoint_sagemaker_api_id" {
  description = "The ID of VPC endpoint for SageMaker API"
  value       = concat(aws_vpc_endpoint.sagemaker_api.*.id, [""])[0]
}

output "vpc_endpoint_sagemaker_api_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for SageMaker API."
  value       = flatten(aws_vpc_endpoint.sagemaker_api.*.network_interface_ids)
}

output "vpc_endpoint_sagemaker_api_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for SageMaker API."
  value       = flatten(aws_vpc_endpoint.sagemaker_api.*.dns_entry)
}

output "vpc_endpoint_sagemaker_runtime_id" {
  description = "The ID of VPC endpoint for SageMaker Runtime"
  value       = concat(aws_vpc_endpoint.sagemaker_runtime.*.id, [""])[0]
}

output "vpc_endpoint_sagemaker_runtime_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for SageMaker Runtime."
  value       = flatten(aws_vpc_endpoint.sagemaker_runtime.*.network_interface_ids)
}

output "vpc_endpoint_sagemaker_runtime_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for SageMaker Runtime."
  value       = flatten(aws_vpc_endpoint.sagemaker_runtime.*.dns_entry)
}

output "vpc_endpoint_appstream_id" {
  description = "The ID of VPC endpoint for AppStream"
  value       = concat(aws_vpc_endpoint.appstream.*.id, [""])[0]
}

output "vpc_endpoint_appstream_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for AppStream."
  value       = flatten(aws_vpc_endpoint.appstream.*.network_interface_ids)
}

output "vpc_endpoint_appstream_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for AppStream."
  value       = flatten(aws_vpc_endpoint.appstream.*.dns_entry)
}

output "vpc_endpoint_athena_id" {
  description = "The ID of VPC endpoint for Athena"
  value       = concat(aws_vpc_endpoint.athena.*.id, [""])[0]
}

output "vpc_endpoint_athena_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for Athena."
  value       = flatten(aws_vpc_endpoint.athena.*.network_interface_ids)
}

output "vpc_endpoint_athena_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for Athena."
  value       = flatten(aws_vpc_endpoint.athena.*.dns_entry)
}

output "vpc_endpoint_rekognition_id" {
  description = "The ID of VPC endpoint for Rekognition"
  value       = concat(aws_vpc_endpoint.rekognition.*.id, [""])[0]
}

output "vpc_endpoint_rekognition_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for Rekognition."
  value       = flatten(aws_vpc_endpoint.rekognition.*.network_interface_ids)
}

output "vpc_endpoint_rekognition_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for Rekognition."
  value       = flatten(aws_vpc_endpoint.rekognition.*.dns_entry)
}

output "vpc_endpoint_efs_id" {
  description = "The ID of VPC endpoint for EFS"
  value       = concat(aws_vpc_endpoint.efs.*.id, [""])[0]
}

output "vpc_endpoint_efs_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for EFS."
  value       = flatten(aws_vpc_endpoint.efs.*.network_interface_ids)
}

output "vpc_endpoint_efs_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for EFS."
  value       = flatten(aws_vpc_endpoint.efs.*.dns_entry)
}

output "vpc_endpoint_cloud_directory_id" {
  description = "The ID of VPC endpoint for Cloud Directory"
  value       = concat(aws_vpc_endpoint.cloud_directory.*.id, [""])[0]
}

output "vpc_endpoint_cloud_directory_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for Cloud Directory."
  value       = flatten(aws_vpc_endpoint.cloud_directory.*.network_interface_ids)
}

output "vpc_endpoint_cloud_directory_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for Cloud Directory."
  value       = flatten(aws_vpc_endpoint.cloud_directory.*.dns_entry)
}


# Static values (arguments)
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = var.azs
}

output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = var.name
}
