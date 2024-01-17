# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "enable_aws_best_practices" {
  description = "Set to TRUE to enable the Security Hub AWS Best Practices subscription"
  type        = bool
  default     = false
}

variable "enable_cis_1_2_0" {
  description = "Set to TRUE to enable the Security Hub CIS v1.2.0 subscription"
  type        = bool
  default     = false
}

variable "enable_cis_1_4_0" {
  description = "Set to TRUE to enable the Security Hub CIS v1.4.0 subscription"
  type        = bool
  default     = false
}

variable "enable_pci_3_2_1" {
  description = "Set to TRUE to enable the Security Hub PCI DSS v3.2.1 subscription"
  type        = bool
  default     = false
}
