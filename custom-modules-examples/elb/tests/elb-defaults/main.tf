resource "aws_security_group" "tester" {
  #checkov:skip=CKV2_AWS_5:Ensure that Security Groups are attached to another resource
  name_prefix = "elb_tester_"
  description = "SG Used to test the ELB Terraform Module"
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
    Name = "elb_tester"
  }
}

module "elb" {
  source = "../../../../custom-modules-examples/elb"

  is_internal     = false
  lb_type         = "application"
  name_tag        = "elb-tester"
  security_groups = [aws_security_group.tester.id]
  subnets         = data.aws_subnets.tester.ids
}
