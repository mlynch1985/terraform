variable "namespace" {
  description = "Specify a stack namespace to prefix all resources"
  type        = string
}

variable "app_role" {
  description = "Provide an application role to label each resource within this module"
  type        = string
}

variable "default_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "image_id" {
  description = "Specify the AMI ID of the image to be used for each EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Specify the EC2 instance size"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Specify the key name to attach and allow access to each EC2 instance"
  type        = string
  default     = ""
}

variable "security_groups" {
  description = "Provide a list of security group IDs to attach to this instance"
  type        = list(string)
}

variable "user_data" {
  description = "Specify a path to a userdata script"
  type        = string
  default     = ""
}

variable "block_device_mapping" {
  description = "Specify an EBS block mapping for block drive"
  type        = map(string)
  default = {
    device_name           = "/dev/xvda"
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
    encrypted             = true
  }
}

variable "enable_detailed_monitoring" {
  description = "Set to true to enable detailed monitoring at 1 minute intervals"
  type        = bool
  default     = false
}

variable "iam_instance_profile" {
  description = "Please specify the iam instance profile to attach to each EC2 instance"
  type        = string
  default     = ""
}

variable "asg_min" {
  description = "Set the minimum number of instances to run"
  type        = number
  default     = 1
}

variable "asg_max" {
  description = "Set the maximum number of instances to run"
  type        = number
  default     = 1
}

variable "asg_desired" {
  description = "Set the desired number of instances to run"
  type        = number
  default     = 1
}

variable "asg_healthcheck_type" {
  description = "Specify whether to use EC2 or ELB healthchecks"
  type        = string
  default     = "EC2"
}

variable "asg_subnets" {
  description = "Provide a list of subnets to deploy EC2 instances into"
  type        = list(string)
}

variable "target_group_arns" {
  description = "Provide a list of ALB or NLB target group arns to link into the ASG"
  type        = list(string)
}