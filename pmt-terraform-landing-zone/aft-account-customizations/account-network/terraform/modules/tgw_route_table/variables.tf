# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "routes" {
  description = "Provide a map of Routes to be created and associated to the route table"
  type = map(object({
    cidr_block           = string
    target_attachment_id = string
  }))
}

variable "rtb_name" {
  description = "Provide a friendly name to populate the Name tag for the route table"
  type        = string
}

variable "source_attachment_id" {
  description = "Provide the TGW Attachment ID to associate the route table with"
  type        = string
}

variable "tgw_id" {
  description = "Optionally provide a Transit Gateway ID to create an attachment to this VPC"
  type        = string
}
