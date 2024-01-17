output "STATE_BUCKET" {
  description = "The Terraform State S3 bucket."
  value       = aws_s3_bucket.secure_s3_bucket.bucket
}

output "DYNAMODB_TABLE" {
  description = "The Terraform State Version Lock DynamoDb Table."
  value       = aws_dynamodb_table.terraform-lock.name
}


output "KMS_KEY" {
  description = "The ARN of the KMS key"
  value       = aws_kms_key.terraform_state_key.id
}