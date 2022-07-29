variable "region" {
  description = "Specify the AWS region to deploy resources into"
  type        = string

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be a valid AWS Region name in all lowercase characters"
  }
}

variable "primary_owner" {
  description = "Specify the name of the stack primary owner"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z ]{1,64}", var.primary_owner))
    error_message = "Must be an alphanumeric value including spaces and a max length of 64 characters"
  }
}

variable "secondary_owner" {
  description = "Specify the name of the stack primary owner"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z ]{1,64}", var.secondary_owner))
    error_message = "Must be an alphanumeric value including spaces and a max length of 64 characters"
  }
}

variable "business_unit" {
  description = "Specify the Business Unit that owns this stack"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z ]{1,64}", var.business_unit))
    error_message = "Must be an alphanumeric value including spaces and a max length of 64 characters"
  }
}

variable "cost_center" {
  description = "Specify the Cost Center for this stack"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z ]{1,64}", var.cost_center))
    error_message = "Must be an alphanumeric value including spaces and a max length of 64 characters"
  }
}

variable "application_name" {
  description = "Specify the application name that this stack supports"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z .-_]{1,64}", var.application_name))
    error_message = "Must be an alphanumeric value including spaces, periods, hyphens or underscores and a max length of 64 characters"
  }
}

variable "application_id" {
  description = "Specify the application ID that this stack supports"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z ._-]{1,16}", var.application_id))
    error_message = "Must be an alphanumeric value including spaces, periods, hyphens or underscores and a max length of 16 characters"
  }
}

variable "application_version" {
  description = "Specify the application version that this stack supports"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z.-]{1,16}", var.application_version))
    error_message = "Must be an alphanumeric value including periods or hyphens and a max length of 16 characters"
  }
}

variable "namespace" {
  description = "Specify a namspace to identify the current deployment in lowercase characters"
  type        = string

  validation {
    condition     = can(regex("[0-9a-z]{1,10}", var.namespace))
    error_message = "Must be an alphanumeric value with only lowercase characters and a max length of 10"
  }
}

variable "environment" {
  description = "Specify an environment to identify the current deployment in lowercase characters"
  type        = string

  validation {
    condition     = can(regex("[0-9a-z]{1,10}", var.environment))
    error_message = "Must be an alphanumeric value with only lowercase characters and a max length of 10"
  }
}

variable "project_name" {
  description = "Specify the project name used to identify the current deployment in lowercase characters"
  type        = string

  validation {
    condition     = can(regex("[0-9a-z]{1,10}", var.project_name))
    error_message = "Must be an alphanumeric value with only lowercase characters and a max length of 10"
  }
}

variable "security_tier" {
  description = "Specify the data security level for this stack"
  type        = string

  validation {
    condition = contains([
      "public", "private", "restricted"
    ], var.security_tier)
    error_message = <<-EOF
      Please specify a valid data security tier:
        "public", "private", "restricted"
EOF
  }
}

variable "patching_tier" {
  description = "Specify the patching level required for this stack"
  type        = string

  validation {
    condition = contains([
      "none", "monthly", "weekly", "daily"
    ], var.patching_tier)
    error_message = <<-EOF
      Please specify a valid patching interval for this stack
        "none", "monthly", "weekly", "daily"
EOF
  }
}
