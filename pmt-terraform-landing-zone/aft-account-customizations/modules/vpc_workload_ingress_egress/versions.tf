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

# Target Account Profile
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      managed_by = "AFT"
    }
  }
}

# Use Control Tower Execution Role to switch into Network Account
provider "aws" {
  region  = var.region
  alias   = "network"
  profile = "ct-management"

  assume_role {
    role_arn     = "arn:aws:iam::${var.network_account_id}:role/AWSControlTowerExecution"
    session_name = "AFT_SESSION"
  }
  default_tags {
    tags = {
      managed_by = "AFT"
    }
  }
}
