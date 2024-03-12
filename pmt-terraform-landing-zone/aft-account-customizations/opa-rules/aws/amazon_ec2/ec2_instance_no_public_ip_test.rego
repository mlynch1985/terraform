package aws.amazon_ec2.ec2_instance_no_public_ip


test_ec2_instance_no_public_ip_valid {
    count(violations) == 0  with input as data.ec2_instance_no_public_ip.valid
}

test_ec2_instance_no_public_ip_ignore {
    count(violations) == 0  with input as data.ec2_instance_no_public_ip.ignore
}

test_ec2_instance_no_public_ip_no_eni {
    count(violations) == 0  with input as data.ec2_instance_no_public_ip.no_eni
}

test_ec2_instance_no_public_ip_invalid {
    r := violations with input as data.ec2_instance_no_public_ip.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "EC2_INSTANCE_NO_PUBLIC_IP"
    r[_]["finding"]["uid"] = "EC2-3"
}

test_ec2_instance_no_public_ip_key_null {
    r := violations with input as data.ec2_instance_no_public_ip.key_null
    count(r) == 1
    r[_]["finding"]["title"] = "EC2_INSTANCE_NO_PUBLIC_IP"
    r[_]["finding"]["uid"] = "EC2-3"
}



