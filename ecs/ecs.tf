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
    depends_on = [aws_iam_role.role, aws_lb_target_group.group, aws_lb_listener.listener]
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
