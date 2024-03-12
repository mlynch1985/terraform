# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "domain" {
  description = "Specify the routing/security domain for this network"
  type        = string
}

variable "amazon_side_asn" {
  description = "ASN used to uniquely identify this TGW. Set between 64512-65534"
  type        = number
}

variable "ram_name" {
  description = "The name of the resource share of TGW"
  type        = string
}

variable "ram_principals" {
  description = "A list of principals to share TGW with. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN"
  type        = list(string)
}
