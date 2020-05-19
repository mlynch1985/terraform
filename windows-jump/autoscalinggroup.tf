## Create EC2 KeyPair for access using personal SSH Public Key
resource "aws_key_pair" "keypair-windowsjump" {
  key_name   = "${var.namespace}-windowsjump"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDY8q+gmo6silx1M0HPK3skBkK64UZXK9zEH8eE7i3MkVZDNa0xl84xC/OMikjYOEc+99wlNERr5FsakLxmIL6H+RmYlENKrTnE6E+qeqQ/yCa4zwer23rXghjgmRVORYsOuH2sLo/EDdu/vy/Cxxjv740pFLeEBHrX94T6uIzMsBL25E9dyPDYOkF99kGLzPlLMsEYhu0Jsvtp5wNjJPSeG9YYuuDeTlE+JDZZmgYZBbWxTbNxRevoocDUxEx63RIJM8YWtGcvO9w2YZs1lr+QrAukpyQgHOPuXTDarypAZ3109kUiwxEpIiWWeM+nPqmEb8/mLI+lnAqu+soosEkHFY6KGJvm3ScR4EdkxfoNAgXQERMSSRu0y4ODlTs+T4lc6UNkCFBmEdd7q3zJazuVOF2WfcuWXZTQouk7g/00EOx+4A8GF1mn+Oz2wLMOyzf55vRHm+tlq8CrWLINeVUk/gyMFA7XpLulEDlkzzqWwBv9l+ehv634/V5Pqpddtz57kkOcmVU7j9VKsb1/3pjLDj/6lxFSL2h3HXNFzVwhIa8QvgEQ6jIQTW1JEMWtlI0GpYZ9h2MkEub+gnlQqvyVtPbNR/tMt2RF8ymhTXiNSaV1Jjb9st39+WdHItE5qIZA5lWXE2uJ1eaxBKDZdqfH2Rq94cmV0gG4ALWnDyvgMw== mlynch1985@gmail.com"
}

## Create EC2 Launch Template
resource "aws_launch_template" "launchtemplate-windowsjump" {
  name                   = "${var.namespace}-windowsjump"
  image_id               = data.aws_ami.windows-server-2019-ami.id
  instance_type          = "t2.xlarge"
  key_name               = aws_key_pair.keypair-windowsjump.key_name
  vpc_security_group_ids = ["${data.aws_security_group.sg-allow-rdp.id}", "${aws_security_group.allow-remote-rdp.id}"]
  user_data              = filebase64("${path.module}/userdata.ps1")
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2-windowsjump-instance-profile.name
  }
}

## Create AutoScalingGroup
resource "aws_autoscaling_group" "asg-windowsjump" {
  name                = "${var.namespace}-windowsjump"
  max_size            = 5
  min_size            = 1
  desired_capacity    = 1
  force_delete        = true
  vpc_zone_identifier = data.aws_subnet_ids.private-subnets.ids
  target_group_arns = [aws_lb_target_group.targetgroup-windowsjump.id]
  termination_policies = ["OldestLaunchConfiguration", "OldestInstance"]
  launch_template {
    id      = aws_launch_template.launchtemplate-windowsjump.id
    version = "$Latest"
  }
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.namespace}-windowsJump"
    propagate_at_launch = true
  }
  tag {
    key                 = "namespace"
    value               = var.namespace
    propagate_at_launch = true
  }
  tag {
    key                 = "environment"
    value               = var.environment
    propagate_at_launch = true
  }
  timeouts {
    delete = "15m"
  }
}
