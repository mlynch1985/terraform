## Create EC2 KeyPair for access using personal SSH Public Key
resource "aws_key_pair" "elasticsearch" {
  key_name   = "${var.namespace}_elasticsearch_kaypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDY8q+gmo6silx1M0HPK3skBkK64UZXK9zEH8eE7i3MkVZDNa0xl84xC/OMikjYOEc+99wlNERr5FsakLxmIL6H+RmYlENKrTnE6E+qeqQ/yCa4zwer23rXghjgmRVORYsOuH2sLo/EDdu/vy/Cxxjv740pFLeEBHrX94T6uIzMsBL25E9dyPDYOkF99kGLzPlLMsEYhu0Jsvtp5wNjJPSeG9YYuuDeTlE+JDZZmgYZBbWxTbNxRevoocDUxEx63RIJM8YWtGcvO9w2YZs1lr+QrAukpyQgHOPuXTDarypAZ3109kUiwxEpIiWWeM+nPqmEb8/mLI+lnAqu+soosEkHFY6KGJvm3ScR4EdkxfoNAgXQERMSSRu0y4ODlTs+T4lc6UNkCFBmEdd7q3zJazuVOF2WfcuWXZTQouk7g/00EOx+4A8GF1mn+Oz2wLMOyzf55vRHm+tlq8CrWLINeVUk/gyMFA7XpLulEDlkzzqWwBv9l+ehv634/V5Pqpddtz57kkOcmVU7j9VKsb1/3pjLDj/6lxFSL2h3HXNFzVwhIa8QvgEQ6jIQTW1JEMWtlI0GpYZ9h2MkEub+gnlQqvyVtPbNR/tMt2RF8ymhTXiNSaV1Jjb9st39+WdHItE5qIZA5lWXE2uJ1eaxBKDZdqfH2Rq94cmV0gG4ALWnDyvgMw== mlynch1985@gmail.com"
}

## Create EC2 Launch Template
resource "aws_launch_template" "elasticsearch" {
  name                   = "${var.namespace}_elasticsearch_launchtemplate"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.elasticsearch.key_name
  vpc_security_group_ids = ["${data.aws_security_group.allow_vpc_ssh.id}", "${aws_security_group.allow_vpc_elasticsearch.id}", "${aws_security_group.allow_vpc_kibana.id}"]
  user_data              = filebase64("${path.module}/userdata.sh")
  iam_instance_profile {
    name = aws_iam_instance_profile.elasticsearch.name
  }
}

## Create AutoScalingGroup
resource "aws_autoscaling_group" "elasticsearch" {
  name                = "${var.namespace}_elasticsearch_autoscalinggroup"
  max_size            = 5
  min_size            = 1
  desired_capacity    = 1
  force_delete        = true
  vpc_zone_identifier = data.aws_subnet_ids.subnets_private.ids
  target_group_arns = [aws_lb_target_group.elasticsearch.id]
  termination_policies = ["OldestLaunchConfiguration", "OldestInstance"]
  launch_template {
    id      = aws_launch_template.elasticsearch.id
    version = "$Latest"
  }
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.namespace}_elasticsearch"
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