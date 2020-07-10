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
