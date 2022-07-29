/* ##### REQUIRED VARIABLES ##### */
variable "namespace" {
  description = "Specify a stack namespace to prefix all resources"
  type        = string
}

variable "component" {
  description = "Provide an application role to label each resource within this module"
  type        = string
}

variable "image_id" {
  description = "Specify the AMI ID of the image to be used for each EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Specify the EC2 instance size"
  type        = string
}

variable "security_groups" {
  description = "Provide a list of security group IDs to attach to this instance"
  type        = list(string)
}

variable "subnet_id" {
  description = "Provide a subnet id to deploy EC2 instances into"
  type        = string
}

/* ###### OPTIONAL VARIABLES ##### */
variable "availability_zone" {
  description = "The AZ to start the instance in"
  type        = string
  default     = ""
}

variable "placement_group" {
  description = "The placement group to start the instance in"
  type        = string
  default     = ""
}

variable "tenancy" {
  description = "Define where this instance is on a Shared or Dedicated host"
  type        = string
  default     = "default"
}

variable "host_id" {
  description = "The ID of the dedicated host that the instance will be assigned to"
  type        = string
  default     = ""
}

variable "cpu_core_count" {
  description = "Sets the number of cores for the instance"
  type        = number
  default     = null
}

variable "cpu_threads_per_core" {
  description = "Set to 1 to disable hyperthreading or 2 to enable it"
  type        = number
  default     = 2
}

variable "disable_api_termination" {
  description = "Set to true to prevent termination of instance via API calls"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "Specify the key name to attach and allow access to each EC2 instance"
  type        = string
  default     = ""
}

variable "monitoring" {
  description = "Set to true to enable detailed monitoring at 1 minute intervals"
  type        = bool
  default     = false
}

variable "associate_public_ip_address" {
  description = "Set to true to enable Public IP Address assignment, must also select Public subnet"
  type        = bool
  default     = false
}

variable "private_ip" {
  description = "Specify the Private IP address to associate to this instance"
  type        = string
  default     = ""
}

variable "source_dest_check" {
  description = "Set to false to allow traffic not destined for this instance"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "Specify a path to a userdata script"
  type        = string
  default     = ""
}

variable "iam_instance_profile" {
  description = "Please specify the iam instance profile arn to attach to each EC2 instance"
  type        = string
  default     = ""
}

variable "default_tags" {
  description = "Specify a map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "root_block_device" {
  description = "Specify a list of EBS block mapping for the root block drive. Limit is 1 for root device"
  type        = list(map(string))
  default     = []
}

variable "ebs_block_device" {
  description = "Specify a list of EBS block mappings for additional block drives"
  type        = list(map(string))
  default     = []
}
