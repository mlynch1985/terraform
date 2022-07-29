data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy" "iam_role_policy_codebuild" {
  name = "GrantCodeBuild"
  role = var.role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:report-group/${var.codebuild_name}*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "iam_role_policy_codecommit" {
  name = "GrantCodeCommit"
  role = var.role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "codecommit:GitPull"
        Effect   = "Allow"
        Resource = var.codecommit_arn
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

resource "aws_iam_role_policy" "iam_role_policy_cloudwatch" {
  name = "GrantCloudWatch"
  role = var.role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.codebuild_name}",
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.codebuild_name}:*"
        ]
      }
    ]
  })
}
