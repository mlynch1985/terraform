variable "codecommit_name" {
  description = "Provide a friendly name for your CodeCommit Repository"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z0-9]{1,24}", var.codecommit_name))
    error_message = "Must be an alphanumeric value and a max length of 24 characters"
  }
}
