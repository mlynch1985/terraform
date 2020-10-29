variable "default_tags" {}
variable "vpc_id" {}
variable "ec2_role" {}
variable "instance_type" {}
variable "common_security_group" {}
variable "user_data" {}
variable "asg_min" {}
variable "asg_max" {}
variable "asg_desired" {}
variable "health_check_type" {}
variable "subnets" {}
variable "target_group" {}

data "aws_ami" "amazon_linux_2" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm*"]
    }
}
