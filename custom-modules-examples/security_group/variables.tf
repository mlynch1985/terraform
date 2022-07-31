variable "group_name_prefix" {
  description = "Specify a name to prefix the security group"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-zA-Z-]{3,36}$", var.group_name_prefix))
    error_message = "Specify a valid security group name prefix"
  }
}

variable "vpc_id" {
  description = "Specify the VPC ID for this security group"
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-zA-Z]{17}$", var.vpc_id))
    error_message = "Please specify a valid VPC ID (^vpc-[0-9a-zA-Z]{17}$)"
  }
}

variable "rules" {
  description = "Specify a list of security group rule maps to attach"
  type = list(object({
    cidr_blocks              = string
    description              = string
    from_port                = string
    protocol                 = string
    source_security_group_id = string
    to_port                  = string
    type                     = string
  }))
  default = [{
    cidr_blocks              = "0.0.0.0/0"
    description              = "default outbound rule"
    from_port                = "0"
    protocol                 = "-1"
    source_security_group_id = null
    to_port                  = "0"
    type                     = "egress"
  }]
}
