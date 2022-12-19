data "aws_iam_policy_document" "tester" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "tester" {
  name_prefix        = "kms_key_tester"
  assume_role_policy = data.aws_iam_policy_document.tester.json
}

module "kms" {
  source = "../../../../custom-modules-examples/kms_key"

  enable_key_rotation = true
  enable_multi_region = false
  iam_roles           = [aws_iam_role.tester.arn]
  key_name            = "kms_key_tester"
}
