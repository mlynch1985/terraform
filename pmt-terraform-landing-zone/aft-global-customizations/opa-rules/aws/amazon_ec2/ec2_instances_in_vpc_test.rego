package aws.amazon_ec2.ec2_instances_in_vpc


test_ec2_instances_in_vpc_valid {
    count(violations) == 0  with input as data.ec2_instances_in_vpc.valid
}

test_ec2_instances_in_vpc_ignore {
    count(violations) == 0  with input as data.ec2_instances_in_vpc.ignore
}

test_ec2_instances_in_vpc_invalid {
    r := violations with input as data.ec2_instances_in_vpc.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "INSTANCES_IN_VPC"
    r[_]["finding"]["uid"] = "EC2-4"
}

test_ec2_instances_in_vpc_key_null {
    r := violations with input as data.ec2_instances_in_vpc.key_null
    count(r) == 1
    r[_]["finding"]["title"] = "INSTANCES_IN_VPC"
    r[_]["finding"]["uid"] = "EC2-4"
}



