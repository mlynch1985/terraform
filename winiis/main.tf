terraform {
  backend "s3" {
    bucket  = "mltemp-sandbox-tfstate"
    region  = "us-east-1"
    encrypt = true
    key     = "wordpress"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "random" {
  region = var.region
}


module "ec2_role" {
  source = "../modules/ec2_role"

  namespace    = var.namespace
  app_role     = var.app_role
  default_tags = local.default_tags
}

module "msad" {
  source = "../modules/msad"

  namespace           = "useast1d"
  app_role            = "appdemo1"
  domain_name         = "example.com"
  vpc_id              = data.aws_vpc.this.id
  subnet_1            = tolist(data.aws_subnet_ids.private.ids)[0]
  subnet_2            = tolist(data.aws_subnet_ids.private.ids)[1]
  edition             = "Enterprise"
  enable_sso          = false
  enable_auto_join    = true
  ad_target_tag_name  = "app_role"
  ad_target_tag_value = "winiis"
  default_tags        = local.default_tags
}




resource "aws_iam_role_policy_attachment" "msad" {
  role       = module.ec2_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}
