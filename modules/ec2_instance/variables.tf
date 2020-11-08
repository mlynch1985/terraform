variable "namespace" {
  description = "Specify a stack namespace to prefix all resources"
  type        = string
}

variable "name" {
  description = "Provide a name to label each resource within this module"
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

variable "enable_detailed_monitoring" {
  description = "Set to true to enable detailed monitoring at 1 minute intervals"
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "Provide a list of security group IDs to attach to this instance"
  type        = list(string)
  default     = []
}

variable "subnet_id" {
  description = "Provide a subnet id to deploy EC2 instances into"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Set to true to enable Public IP Address assignment, must also select Public subnet"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "Specify a path to a userdata script"
  type        = string
  default     = ""
}

variable "iam_instance_profile" {
  description = "Please specify the iam instance profile to attach to each EC2 instance"
  type        = string
  default     = ""
}

variable "root_block_device" {
  description = "Specify an EBS block mapping for the root block drive"
  type        = map(string)
  default = {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
    encrypted             = true
  }
}

variable "ebs_block_device" {
  description = "Specify an EBS block mapping for a secondary block drive"
  type        = map(string)
  default = {
    device_name           = "/dev/xvdb"
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
    encrypted             = true
  }
}

variable "enable_second_drive" {
  description = "Set to true to enable second EBS block device"
  type        = bool
  default     = false
}
