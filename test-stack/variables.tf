variable "region" {
  description = "Specify the AWS region to deploy resources into"
  type        = string

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be a valid AWS Region name"
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

variable "creator" {
  description = "Specify the name of the stack creator/builder"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z ]{1,64}", var.creator))
    error_message = "Must be an alphanumeric value including spaces and a max length of 64 characters"
  }
}

variable "owner" {
  description = "Specify the name of the stack owner"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z ]{1,64}", var.owner))
    error_message = "Must be an alphanumeric value including spaces and a max length of 64 characters"
  }
}

variable "organization" {
  description = "Specify the Organization name the owns this infrastructure"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z ]{1,64}", var.organization))
    error_message = "Must be an alphanumeric value including spaces and a max length of 64 characters"
  }
}
