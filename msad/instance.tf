resource "aws_instance" "instance" {
    ami = data.aws_ami.windows-2019.image_id
    instance_type = "t3a.large"
    vpc_security_group_ids = [aws_security_group.ec2.id]
    subnet_id = data.aws_subnet.public-a.id
    associate_public_ip_address = true
    iam_instance_profile = aws_iam_instance_profile.profile.name
    tags = {
        Name = "sample-msad-intance"
    }
}

resource "aws_ssm_association" "adjoin" {
    depends_on = [aws_directory_service_directory.directory]
    name = "AWS-JoinDirectoryServiceDomain"
    targets {
        key = "InstanceIds"
        values = [aws_instance.instance.id]
    }
    parameters = {
        directoryId = aws_directory_service_directory.directory.id
        directoryName = aws_directory_service_directory.directory.name
        dnsIpAddresses = element(split(", ", join(", ", aws_directory_service_directory.directory.dns_ip_addresses)), 0)
    }
}
