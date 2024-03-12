# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  global_vars = yamldecode(file(abspath("../${path.module}/global_vars.yaml")))
}

module "account_kms_key" {
  source = "./modules/account_kms_key"

  providers = {
    aws = aws.region1
  }
}

module "account_kms_key_replica" {
  source              = "./modules/account_kms_key_replica"
  primary_kms_key_arn = module.account_kms_key.kms_key_arn

  # Skip Region1 as that is the primary key
  providers = {
    aws.region2 = aws.region2,
    aws.region3 = aws.region3,
    aws.region4 = aws.region4
  }
}

module "enable_ebs_default_encryption" {
  source = "./modules/enable_ebs_default_encryption"

  providers = {
    aws.region1 = aws.region1,
    aws.region2 = aws.region2,
    aws.region3 = aws.region3,
    aws.region4 = aws.region4
  }
}

resource "aws_s3_account_public_access_block" "global-block" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
