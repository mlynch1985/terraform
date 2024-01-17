variable "bucket_name" {
  description = "The name of the S3 bucket (3 - 63 characters long)"
  type        = string
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  default     = false
  type        = bool
}

variable "tags" {
  description = "Add these tags to all resources created by this module"
  default = {
    Generator = "Terraform"
  }
  type = map(any)
}

variable "mfa_delete" {
  description = "Forces deletion of object to identities with mfa auth. Only the bucket owner (root account) can enable MFA delete"
  default     = false
  type        = bool
}

variable "lifecycle_rule_current_version" {
  description = "change storage class after days for current objects"
  type        = map(string)
  default = {
    days          = 360
    storage_class = "GLACIER"
  }
}

variable "lifecycle_rule_noncurrent_version" {
  description = "change storage class after days for non-current objects (older versions)"
  type        = map(string)
  default = {
    days          = 90
    storage_class = "GLACIER"
  }
}

variable "lifecycle_rule_expiration" {
  description = "Specifies a period in the object's expire"
  type        = map(string)
  default = {
    date                         = null
    days                         = null
    expired_object_delete_marker = null
  }
}