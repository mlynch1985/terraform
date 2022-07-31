data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["${var.service}.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  assume_role_policy    = data.aws_iam_policy_document.trust_policy.json
  force_detach_policies = true
  name_prefix           = var.role_name
}

resource "aws_iam_instance_profile" "this" {
  name = aws_iam_role.this.name
  role = aws_iam_role.this.id
}

resource "aws_iam_policy" "inline" {
  count = var.inline_policy_json != "" ? 1 : 0

  policy = var.inline_policy_json
}

resource "aws_iam_role_policy_attachment" "inline" {
  count = var.inline_policy_json != "" ? 1 : 0

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.inline.arn
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.key
}
