# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_organizations_policy" "this" {
  name    = var.scp_name
  content = file(var.json_file)
}

resource "aws_organizations_policy_attachment" "this" {
  for_each  = { for ou in var.ou_list : ou => ou }
  policy_id = aws_organizations_policy.this.id
  target_id = each.value
}

