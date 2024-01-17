# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_config_config_rule" "region1" {
  for_each = { for name, rule in var.rules : name => rule }

  name             = each.key
  description      = try(each.value.description, "")
  input_parameters = try(each.value.input_parameters, "")

  source {
    owner             = "AWS"
    source_identifier = each.value.source_identifier
  }

  provider = aws.region1
}

resource "aws_config_config_rule" "region2" {
  for_each = { for name, rule in var.rules : name => rule }

  name             = each.key
  description      = try(each.value.description, "")
  input_parameters = try(each.value.input_parameters, "")

  source {
    owner             = "AWS"
    source_identifier = each.value.source_identifier
  }

  provider = aws.region2
}

resource "aws_config_config_rule" "region3" {
  for_each = { for name, rule in var.rules : name => rule }

  name             = each.key
  description      = try(each.value.description, "")
  input_parameters = try(each.value.input_parameters, "")

  source {
    owner             = "AWS"
    source_identifier = each.value.source_identifier
  }

  provider = aws.region3
}
