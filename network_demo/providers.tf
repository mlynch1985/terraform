terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.0.0"
    }
  }
}

locals {
  hub_account_id   = ""
  spoke_account_id = ""
}

provider "aws" {
  region = "us-east-2"
}

provider "aws" {
  region = "us-east-2"
  alias  = "nonprod-hub-use2"
  assume_role {
    role_arn     = "arn:aws:iam::${hub_account_id}:role/AWSControlTowerExecution"
    session_name = "nonprod-hub-use2"
  }
}

provider "aws" {
  region = "us-west-2"
  alias  = "nonprod-hub-usw2"
  assume_role {
    role_arn     = "arn:aws:iam::${hub_account_id}:role/AWSControlTowerExecution"
    session_name = "nonprod-hub-usw2"
  }
}

provider "aws" {
  region = "us-east-2"
  alias  = "nonprod-spoke-use2"
  assume_role {
    role_arn     = "arn:aws:iam::${spoke_account_id}:role/AWSControlTowerExecution"
    session_name = "nonprod-spoke-use2"
  }
}

provider "aws" {
  region = "us-west-2"
  alias  = "nonprod-spoke-usw2"
  assume_role {
    role_arn     = "arn:aws:iam::${spoke_account_id}:role/AWSControlTowerExecution"
    session_name = "nonprod-spoke-usw2"
  }
}
