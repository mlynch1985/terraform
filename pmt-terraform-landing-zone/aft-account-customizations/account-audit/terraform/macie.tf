# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_macie2_member" "region1" {
  for_each = {
    for account in local.account_list : account.id => account
    if account.id != data.aws_caller_identity.current.account_id # Ignore current account
  }

  account_id = each.value.id
  email      = each.value.email
  invite     = false
  status     = "ENABLED"

  provider   = aws.region1
  depends_on = [local.account_list]

  lifecycle {
    ignore_changes = [email, invite]
  }
}

resource "aws_macie2_member" "region2" {
  for_each = {
    for account in local.account_list : account.id => account
    if account.id != data.aws_caller_identity.current.account_id # Ignore current account
  }

  account_id = each.value.id
  email      = each.value.email
  invite     = false
  status     = "ENABLED"

  provider   = aws.region2
  depends_on = [local.account_list]

  lifecycle {
    ignore_changes = [email, invite]
  }
}

resource "aws_macie2_custom_data_identifier" "region1" {
  name                   = "sample-ssn"
  regex                  = "^[0-9]{3}-[0-9]{2}-[0-9]{4}$"
  description            = "Sample data identifier for SSN"
  maximum_match_distance = 10

  provider = aws.region1
}

resource "aws_macie2_custom_data_identifier" "region2" {
  name                   = "sample-ssn"
  regex                  = "^[0-9]{3}-[0-9]{2}-[0-9]{4}$"
  description            = "Sample data identifier for SSN"
  maximum_match_distance = 10

  provider = aws.region2
}
