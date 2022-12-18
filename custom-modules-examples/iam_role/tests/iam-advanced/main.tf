module "iam_role" {
  source = "../../../../custom-modules-examples/iam_role"

  inline_policy_json = [
    {
      Version = "2012-10-17"
      Statement = [{
        Sid    = "GrantS3ReadOnly"
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:List*"
        ]
        Resource   = ["*"]
        Conditions = []
      }]
    },
    {
      Version = "2012-10-17"
      Statement = [{
        Sid    = "GrantCloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource   = ["*"]
        Conditions = []
      }]
    }
  ]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]

  role_name = "iam_role_tester"
  service   = "ec2"
}
