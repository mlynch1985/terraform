# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "ou_list" {
  description = "A list of OU IDs to associate the SCP with."
  type        = list(string)
}

variable "json_file" {
  description = "path to json file for SCP."
  type        = string
}

variable "scp_name" {
  description = "SCP name."
  type        = string
}
