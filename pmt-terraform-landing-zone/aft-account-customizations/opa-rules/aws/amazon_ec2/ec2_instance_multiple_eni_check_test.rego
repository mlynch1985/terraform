package aws.amazon_ec2.ec2_instance_multiple_eni_check


test_ec2_instance_multiple_eni_check_valid {
    count(violations) == 0  with input as data.ec2_instance_multiple_eni_check.valid
}

test_ec2_instance_multiple_eni_check_ignore {
    count(violations) == 0  with input as data.ec2_instance_multiple_eni_check.ignore
}

test_ec2_instance_multiple_eni_check_invalid {
    r := violations with input as data.ec2_instance_multiple_eni_check.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "EC2_INSTANCE_MULTIPLE_ENI_CHECK"
    r[_]["finding"]["uid"] = "EC2-2"
}

test_ec2_instance_multiple_eni_check_key_null {
    count(violations) == 0  with input as data.ec2_instance_multiple_eni_check.key_null
}



