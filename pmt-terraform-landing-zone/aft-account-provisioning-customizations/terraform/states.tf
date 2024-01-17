# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_sfn_state_machine" "aft_account_provisioning_customizations" {
  name       = "aft-account-provisioning-customizations"
  role_arn   = aws_iam_role.aft_states.arn
  definition = templatefile("${path.module}/states/customizations.asl.json", {})
}
