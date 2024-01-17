resource "aws_dynamodb_table" "terraform-lock" {
    name           = "terraform_state"
    read_capacity  = 5
    write_capacity = 5
    point_in_time_recovery {
        enabled = true
    }
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
    tags = {
        "Name" = "DynamoDB Terraform State Lock Table"
    }

    server_side_encryption {
      enabled = true 
      kms_key_arn = aws_kms_key.terraform_state_lock_key.arn
    }
}

