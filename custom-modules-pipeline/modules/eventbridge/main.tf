data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy" "iam_role_policy_eventbridge" {
  name = "GrantEventBridge"
  role = var.role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["codepipeline:StartPipelineExecution"]
        Effect   = "Allow"
        Resource = var.codepipeline_arn
      }
    ]
  })
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = var.codecommit_name
  description = "Trigger our TF Modules CodePipeline when updating or merging into the Main branch"
  role_arn    = var.role_arn

  event_pattern = <<-EOF
{
    "detail-type": ["CodeCommit Repository State Change"],
    "source": ["aws.codecommit"],
    "detail.repositoryName": ["${var.codecommit_name}"],
    "detail.referenceName": ["main"]
}
EOF
}

resource "aws_cloudwatch_event_target" "event_target" {
  rule      = aws_cloudwatch_event_rule.event_rule.name
  target_id = "TriggerCodePipeline"
  arn       = var.codepipeline_arn
  role_arn  = var.role_arn
}
