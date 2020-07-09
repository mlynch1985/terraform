#### ECS Stack ####
#
# This module will deploy a sample ECS Cluster hosting a PHP site across two availability zones.
#
###################

variable "region" { default = "us-east-1" }

provider "aws" {
    region  = var.region
    version = "~> 2.69"
}

locals {
    zones = ["A", "B", "C"]
}

data "aws_availability_zones" "available" {
    state = "available"
}

data "aws_vpc" "vpc" {
    tags = {
        Name = "terraform-vpc"
    }
}

data "aws_subnet_ids" "public" {
    vpc_id = data.aws_vpc.vpc.id
    tags = {
        Tier = "Public"
    }
}

data "aws_subnet_ids" "private" {
    vpc_id = data.aws_vpc.vpc.id
    tags = {
        Tier = "Private"
    }
}

resource "aws_iam_role" "role" {
    name = "sample-ecs-role"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ecs-tasks.amazonaws.com"
            }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "policy" {
    name = "ecs-execution-policy"
    role = aws_iam_role.role.id
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GrantECSExecution",
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_security_group" "elb" {
    name = "sample-ecs-elbsecuritygroup"
    description = "Allows HTTP access from the World to our ELB"
    vpc_id = data.aws_vpc.vpc.id
    ingress {
        description = "Allows HTTP access from the World to our ELB"
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sample-ecs-elbsecuritygroup"
    }
}

resource "aws_security_group" "ecs" {
    name = "sample-ecs-ecssecuritygroup"
    description = "Allows HTTP access from the ELB to our ECS instances"
    vpc_id = data.aws_vpc.vpc.id
    ingress {
        description = "Allows HTTP access from the ELB to our ECS instances"
        protocol = "tcp"
        from_port = 80
        to_port = 80
        security_groups = [aws_security_group.elb.id]
    }
    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sample-ecs-ecssecuritygroup"
    }
}

resource "aws_lb" "elb" {
    name = "sample-ecs-elb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.elb.id]
    subnets = [for id in data.aws_subnet_ids.public.ids : id]
    tags = {
        Name = "sample-ecs-elb"
    }
}

resource "aws_lb_target_group" "group" {
    name = "sample-ecs-targetgroup"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.vpc.id
    target_type = "ip"
    tags = {
        Name = "sample-ecs-targetgroup"
    }
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.elb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.group.arn
    }
}

resource "aws_ecs_cluster" "cluster" {
    name = "sample_ecs_cluster"
    tags = {
        Name = "sample-ecs-cluster"
    }
}

resource "aws_ecs_task_definition" "task" {
    family = "sample-service"
    network_mode = "awsvpc"
    cpu = 256
    memory = 512
    requires_compatibilities = ["FARGATE"]
    task_role_arn = aws_iam_role.role.arn
    container_definitions = <<EOF
[
    {
        "name": "sample-ecs-container",
        "image": "amazon/amazon-ecs-sample",
        "cpu": 256,
        "memory": 512,
        "portMappings": [
            {
                "containerPort": 80,
                "hostPort": 80
            }
        ]
    }
]
EOF
}

resource "aws_ecs_service" "service" {
    depends_on = [aws_iam_role.role]
    name = "sample-ecs-service"
    cluster = aws_ecs_cluster.cluster.arn
    deployment_maximum_percent = 200
    deployment_minimum_healthy_percent = 50
    desired_count = 3
    launch_type = "FARGATE"
    task_definition = aws_ecs_task_definition.task.arn
    load_balancer {
        target_group_arn = aws_lb_target_group.group.arn
        container_name = "sample-ecs-container"
        container_port = 80
    }
    network_configuration {
        subnets = [for s in data.aws_subnet_ids.private.ids : s]
        security_groups = [aws_security_group.ecs.id]
        assign_public_ip = false
    }
}
