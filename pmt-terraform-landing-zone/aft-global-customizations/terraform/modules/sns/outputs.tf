# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

################################################################################
# Topic
################################################################################

output "topic_arn" {
  description = "The ARN of the SNS topic, as a more obvious property (clone of id)"
  value       = try(aws_sns_topic.this[0].arn, null)
}

output "topic_id" {
  description = "The ARN of the SNS topic"
  value       = try(aws_sns_topic.this[0].id, null)
}

output "topic_name" {
  description = "The name of the topic"
  value       = try(aws_sns_topic.this[0].name, null)
}

output "topic_owner" {
  description = "The AWS Account ID of the SNS topic owner"
  value       = try(aws_sns_topic.this[0].owner, null)
}

################################################################################
# Subscription(s)
################################################################################

output "subscriptions" {
  description = "Map of subscriptions created and their attributes"
  value       = aws_sns_topic_subscription.this
}
