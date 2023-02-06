terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = local.region1_name
}

provider "aws" {
  region = local.region1_name
  alias  = "region1"
}

provider "aws" {
  region = local.region2_name
  alias  = "region2"
}

provider "aws" {
  region = local.region3_name
  alias  = "region3"
}
