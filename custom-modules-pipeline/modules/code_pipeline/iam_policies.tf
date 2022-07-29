data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy" "iam_role_policy_codecommit" {
  name = "GrantCodeCommit"
  role = var.role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:UploadArchive",
          "codecommit:GetUploadArchiveStatus"
        ]
        Effect   = "Allow"
        Resource = var.codecommit_arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "iam_role_policy_codebuild" {
  name = "GrantCodeBuild"
  role = var.role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:project/${var.codebuild_name}*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "iam_role_policy_s3bucket" {
  name = "GrantS3Bucket"
  role = var.role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:UploadArchive"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "iam_role_policy_kmskey" {
  name = "GrantKmsKey"
  role = var.role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "kms:GenerateDataKey"
        Effect   = "Allow"
        Resource = var.pipeline_key_arn
      }
    ]
  })
}
