# S3
resource "aws_kms_key" "terraform_state_key" {
  description             = "KMS key for Terraform state encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "terraform_state_alias" {
  name          = "alias/terraform-state-key"
  target_key_id = aws_kms_key.terraform_state_key.key_id
}

# DynamoDb
resource "aws_kms_key" "terraform_state_lock_key" {
  description             = "KMS key for Terraform state encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "terraform_state_lock_alias" {
  name          = "alias/terraform-state-lock-key"
  target_key_id = aws_kms_key.terraform_state_lock_key.key_id
}