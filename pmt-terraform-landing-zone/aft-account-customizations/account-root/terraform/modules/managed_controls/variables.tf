# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "controls" {

  type = list(object({
    control_names           = list(string)
    organizational_unit_ids = list(string)
  }))

  description = "Configuration of AWS Control Tower Guardrails for the whole organization"
}
