# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = var.name
  destination = "extended_s3"

  server_side_encryption {
    enabled  = true
    key_type = "CUSTOMER_MANAGED_CMK"
    key_arn  = var.firehose_kms_key
  }

  extended_s3_configuration {
    role_arn           = var.role_arn
    bucket_arn         = var.bucket_arn
    buffering_size     = 128
    buffering_interval = 60
    prefix             = "AWSLogs/${data.aws_caller_identity.current.account_id}/${data.aws_region.current.name}/"
    kms_key_arn        = var.bucket_kms_key

    ## Kinesis Dynamic Partitioning currently cannot support GZIP'd CloudWatch logs so we cannot separate based on log group name
    # prefix              = "AWSLogs/${data.aws_caller_identity.current.account_id}/${data.aws_region.current.name}/!{partitionKeyFromQuery:logGroup}/"
    # error_output_prefix = "errors/!{timestamp:yyyy}/!{timestamp:MM}/!{timestamp:dd}/!{timestamp:HH}/!{firehose:error-output-type}/"

    # dynamic_partitioning_configuration {
    #   enabled = true
    # }

    # processing_configuration {
    #   enabled = true

    #   processors {
    #     type = "MetadataExtraction"
    #     parameters {
    #       parameter_name  = "MetadataExtractionQuery"
    #       parameter_value = "{logGroup:.logGroup}"
    #     }
    #     parameters {
    #       parameter_name  = "JsonParsingEngine"
    #       parameter_value = "JQ-1.6"
    #     }
    #   }
    # }
  }
}
