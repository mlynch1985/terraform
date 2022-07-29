resource "aws_codecommit_repository" "codecommit_repo" {
  #checkov:skip=CKV2_AWS_37:This pipeline is intentionally bypassing the approval step for demo purposes
  repository_name = var.codecommit_name
  description     = "This repository will store custom developed Terraform modules"
  default_branch  = "main"
}
