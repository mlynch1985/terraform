# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

terraform {
  required_version = ">= 0.15.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.15"
    }
  }
}
