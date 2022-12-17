resource "aws_security_group" "tester" {
  #checkov:skip=CKV2_AWS_5:Ensure that Security Groups are attached to another resource
  name_prefix = "asg_tester_"
  description = "SG Used to test the ASG Terraform Module"
  vpc_id      = var.vpc_id

  egress {
    description      = "Allow all outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "asg_tester"
  }
}

module "asg" {
  source = "../../../../custom-modules-examples/asg"

  image_id               = data.aws_ami.amazonlinux2.id
  instance_type          = "c5.large"
  server_name            = "asg_module_tester"
  subnets                = data.aws_subnets.tester.ids
  vpc_security_group_ids = [aws_security_group.tester.id]
}
