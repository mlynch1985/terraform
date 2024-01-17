# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_iam_role" "aft_states" {
  name               = "aft-account-provisioning-customizations-role"
  assume_role_policy = templatefile("${path.module}/iam/trust-policies/states.tpl", { none = "none" })
}

resource "aws_iam_role_policy" "aft_states" {
  name = "aft-account-provisioning-customizations-policy"
  role = aws_iam_role.aft_states.id

  policy = templatefile("${path.module}/iam/role-policies/iam-aft-states.tpl", {
    account_provisioning_customizations_sfn_arn = aws_sfn_state_machine.aft_account_provisioning_customizations.arn
  })
}
