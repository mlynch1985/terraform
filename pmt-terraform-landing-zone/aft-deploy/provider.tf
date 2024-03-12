# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = local.ct_home_region

  default_tags {
    tags = {
      managed_by = "AFT"
    }
  }
}

provider "aws" {
  alias  = "aft-management"
  region = local.ct_home_region
  assume_role {
    role_arn = "arn:aws:iam::${local.aft_management_account_id}:role/AWSControlTowerExecution"
  }
  default_tags {
    tags = {
      managed_by = "AFT"
    }
  }
}
