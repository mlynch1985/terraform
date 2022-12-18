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
  name_prefix           = var.role_name != null ? "${var.role_name}_" : null
}

resource "aws_iam_instance_profile" "this" {
  count = var.service == "ec2" ? 1 : 0 # Only create Instance Profile if attaching to EC2 instances

  name_prefix = var.role_name != null ? "${var.role_name}_" : null
  role        = aws_iam_role.this.id
}

resource "aws_iam_policy" "inline" {
  count = length(var.inline_policy_json)

  policy = jsonencode(var.inline_policy_json[count.index])
}

resource "aws_iam_role_policy_attachment" "inline" {
  count = length(var.inline_policy_json)

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.inline[count.index].arn
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.key
}
