package aws.amazon_ec2.ec2_ebs_encryption_by_default


test_ec2_ebs_encryption_by_default_valid {
    count(violations) == 0  with input as data.ec2_ebs_encryption_by_default.valid
}

test_ec2_ebs_encryption_by_default_ignore {
    count(violations) == 0  with input as data.ec2_ebs_encryption_by_default.ignore
}

test_ec2_ebs_encryption_by_default_invalid {
    r := violations with input as data.ec2_ebs_encryption_by_default.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "EC2_EBS_ENCRYPTION_BY_DEFAULT"
    r[_]["finding"]["uid"] = "EC2-1"
}

test_ec2_ebs_encryption_by_default_key_null {
    count(violations) == 0  with input as data.ec2_ebs_encryption_by_default.key_null
}



