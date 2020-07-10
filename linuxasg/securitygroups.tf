resource "aws_security_group" "elb" {
    name = "sample-linuxasg-elbsecuritygroup"
    description = "Allows HTTP 80 to the ELB from the world"
    vpc_id = data.aws_vpc.vpc.id
    ingress {
        description = "Allows HTTP 80 to the ELB from the world"
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
        Name = "sample-linuxasg-elbsecuritygroup"
    }
}

resource "aws_security_group" "asg" {
    name = "sample-linuxasg-asgsecuritygroup"
    description = "Allows HTTP 80 to our EC2 instances from the ELB"
    vpc_id = data.aws_vpc.vpc.id
    ingress {
        description = "Allows HTTP 80 to our EC2 instances from the ELB"
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
        Name = "sample-linuxasg-asgsecuritygroup"
    }
}
