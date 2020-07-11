resource "aws_security_group" "ec2" {
    name = "sample-msad-securitygroup"
    description = "Allows communication to all members of this security group"
    vpc_id = data.aws_vpc.vpc.id
    ingress {
        description = "Allows communication to all members of this security group"
        protocol = "-1"
        from_port = 0
        to_port = 0
        self = true
    }
    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sample-msad-securitygroup"
    }
}
