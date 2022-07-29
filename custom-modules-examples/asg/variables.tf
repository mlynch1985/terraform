variable "image_id" {
  description = "Specify the AMI ID of the image to be used for each EC2 instance"
  type        = string

  validation {
    condition     = can(regex("^ami-[0-9a-zA-Z]{17}$", var.image_id))
    error_message = "Please specify a valid AMI ID (^ami-[0-9a-zA-Z]{17}$)"
  }
}

variable "instance_type" {
  description = "Specify the EC2 instance size"
  type        = string

  validation {
    condition = contains([
      "t3.micro", "t3.medium", "t3.large", "t3.xlarge",
      "m5.micro", "m5.medium", "m5.large", "m5.xlarge",
      "c5.micro", "c5.medium", "c5.large", "c5.xlarge"
    ], var.instance_type)
    error_message = <<-EOF
      Please specify an approved instance_type only:
        "t3.micro", "t3.medium", "t3.large", "t3.xlarge",
        "m5.micro", "m5.medium", "m5.large", "m5.xlarge",
        "c5.micro", "c5.medium", "c5.large", "c5.xlarge"
EOF
  }
}

variable "server_name" {
  description = "Specify the server name to used for the Name Tag"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-zA-Z-_]{1,64}$", var.server_name))
    error_message = "Please specify a valid Server Name between 1 and 64 characters long (^[0-9a-zA-Z-_]{1,64}$)"
  }
}

variable "vpc_security_group_ids" {
  description = "Provide a list of security group IDs to attach to this instance"
  type        = list(string)

  validation {
    condition = alltrue([
      for group_id in var.vpc_security_group_ids : can(regex("^sg-[0-9a-zA-Z]{17}$", group_id))
    ])
    error_message = "Please specify a list containing at least one valid Security Group ID (^sg-[0-9a-zA-Z]{17}$)"
  }
}

variable "user_data" {
  description = "Specify a path to a userdata script"
  type        = string
  default     = ""
}

variable "block_device_mappings" {
  description = "Specify a list of block device mappings to attach to each instance"
  type        = any
  default     = []
}

variable "kms_key_arn" {
  description = "Provide the KMS Key ARN used to encrypt the EBS Volumes"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:key/[a-zA-Z0-9-]{36}$", var.kms_key_arn))
    error_message = "Please specify a valid KMS Key ARN (^arn:aws:kms:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:key/[a-zA-Z0-9-]{36}$)"
  }
}

variable "iam_instance_profile" {
  description = "Please specify the iam instance profile arn to attach to each EC2 instance"
  type        = any

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:instance-profile/[a-zA-Z0-9-_]{1,64}$", var.iam_instance_profile))
    error_message = "Please specify a valid IAM Instance Profile ARN (^arn:aws:iam::[0-9]{12}:instance-profile/[a-zA-Z0-9-_]{1,64}$)"
  }
}

variable "max_size" {
  description = "The maximum size of the auto scaling group"
  type        = number
  default     = 1

  validation {
    condition     = var.max_size >= 1 && var.max_size <= 16
    error_message = "Please specify a max size between 1 and 16"
  }
}

variable "min_size" {
  description = "The minimum size of the auto scaling group"
  type        = number
  default     = 1

  validation {
    condition     = var.min_size >= 1 && var.min_size <= 16
    error_message = "Please specify a min size between 1 and 16"
  }
}

variable "healthcheck_grace_period" {
  description = "Time in seconds after instance launch before performing healthchecks"
  type        = number
  default     = 300

  validation {
    condition     = var.healthcheck_grace_period >= 30 && var.healthcheck_grace_period <= 3600
    error_message = "Please specify in seconds the healthcheck grace period between 30 seconds and 1 hour (3600 seconds)"
  }
}

variable "healthcheck_type" {
  description = "Specify EC2 or ELB to determine how healthchecks should be performed"
  type        = string
  default     = "EC2"

  validation {
    condition     = contains(["EC2", "ELB"], var.healthcheck_type)
    error_message = "Please specify a valid healthcheck type either EC2 or ELB"
  }
}

variable "desired_capacity" {
  description = "The desired capacity of the auto scaling group"
  type        = number
  default     = 1

  validation {
    condition     = var.desired_capacity >= 1 && var.desired_capacity <= 16
    error_message = "Please specify a valid desired capacity between 1 and 16"
  }
}

variable "subnets" {
  description = "List of subnet IDs to launch instances in"
  type        = list(string)

  validation {
    condition = alltrue([
      for subnet in var.subnets : can(regex("^subnet-[0-9a-zA-Z]{17}$", subnet))
    ])
    error_message = "Please specify a list containing at least one valid Subnet ID (^subnet-[0-9a-zA-Z]{17}$)"
  }
}

variable "target_group_arns" {
  description = "A list of target group ARNs to associated instances with"
  type        = list(string)
  default     = []
}
