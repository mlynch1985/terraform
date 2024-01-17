# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

output "arn" {
  value       = resource.aws_kinesis_firehose_delivery_stream.extended_s3_stream.arn
  description = "ARN of Kinesis Firehose delivery stream"
}
