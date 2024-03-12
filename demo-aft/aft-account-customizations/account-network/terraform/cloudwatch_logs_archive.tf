# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_ssm_parameter" "cloudwatch_logs_archive_kms_key_region1_arn" {
  name     = "/aft/account/log-archive/cloudwatch_logs_archive_kms_key_region1_arn"
  provider = aws.aft-management
}

data "aws_ssm_parameter" "cloudwatch_logs_archive_kms_key_replica_region2_arn" {
  name     = "/aft/account/log-archive/cloudwatch_logs_archive_kms_key_replica_region2_arn"
  provider = aws.aft-management
}

data "aws_ssm_parameter" "cloudwatch_logs_archive_kms_key_replica_region3_arn" {
  name     = "/aft/account/log-archive/cloudwatch_logs_archive_kms_key_replica_region3_arn"
  provider = aws.aft-management
}

data "aws_ssm_parameter" "cloudwatch_logs_archive_bucket_arn" {
  name     = "/aft/account/log-archive/cloudwatch_logs_archive_bucket_arn"
  provider = aws.aft-management
}

module "cloudwatch_log_archive_region1" {
  source           = "../../modules/cloudwatch_log_archive"
  bucket_arn       = data.aws_ssm_parameter.cloudwatch_logs_archive_bucket_arn.value
  bucket_kms_key   = data.aws_ssm_parameter.cloudwatch_logs_archive_kms_key_region1_arn.value
  firehose_kms_key = data.aws_ssm_parameter.cloudwatch_logs_archive_kms_key_region1_arn.value

  cw_log_group_names = [
    module.staging_vpc_egress_region1.cloudwatch_log_group_name,
    module.staging_vpc_ingress_region1.cloudwatch_log_group_name,
    module.staging_vpc_inspection_region1.cloudwatch_log_group_name,
    module.staging_vpc_shared_services_region1.cloudwatch_log_group_name
  ]

  providers = {
    aws = aws.region1
  }
}

module "cloudwatch_log_archive_region2" {
  source           = "../../modules/cloudwatch_log_archive"
  bucket_arn       = data.aws_ssm_parameter.cloudwatch_logs_archive_bucket_arn.value
  bucket_kms_key   = data.aws_ssm_parameter.cloudwatch_logs_archive_kms_key_region1_arn.value
  firehose_kms_key = data.aws_ssm_parameter.cloudwatch_logs_archive_kms_key_replica_region2_arn.value

  cw_log_group_names = [
    module.staging_vpc_egress_region2.cloudwatch_log_group_name,
    module.staging_vpc_ingress_region2.cloudwatch_log_group_name,
    module.staging_vpc_inspection_region2.cloudwatch_log_group_name,
    module.staging_vpc_shared_services_region2.cloudwatch_log_group_name
  ]

  providers = {
    aws = aws.region2
  }
}

module "cloudwatch_log_archive_region3" {
  source           = "../../modules/cloudwatch_log_archive"
  bucket_arn       = data.aws_ssm_parameter.cloudwatch_logs_archive_bucket_arn.value
  bucket_kms_key   = data.aws_ssm_parameter.cloudwatch_logs_archive_kms_key_region1_arn.value
  firehose_kms_key = data.aws_ssm_parameter.cloudwatch_logs_archive_kms_key_replica_region3_arn.value

  cw_log_group_names = [
    module.staging_vpc_egress_region3.cloudwatch_log_group_name,
    module.staging_vpc_ingress_region3.cloudwatch_log_group_name,
    module.staging_vpc_inspection_region3.cloudwatch_log_group_name,
    module.staging_vpc_shared_services_region3.cloudwatch_log_group_name
  ]

  providers = {
    aws = aws.region3
  }
}
