data "aws_caller_identity" "current" {}
data "aws_organizations_organization" "current" {}
data "aws_region" "current" {}

locals {
  create_access_log_bucket = var.access_log_bucket_arn == null ? true : false
  access_log_bucket_id     = local.create_access_log_bucket ? null : split(":", var.access_log_bucket_arn)[5]
}
