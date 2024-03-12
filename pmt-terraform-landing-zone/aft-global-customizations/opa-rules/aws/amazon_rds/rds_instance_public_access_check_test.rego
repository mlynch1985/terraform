package aws.amazon_rds.rds_instance_public_access_check


test_rds_instance_public_access_check_valid {
    count(violations) == 0  with input as data.rds_instance_public_access_check.valid
}

test_rds_instance_public_access_check_ignore {
    count(violations) == 0  with input as data.rds_instance_public_access_check.ignore
}

test_rds_instance_public_access_check_no_key {
    count(violations) == 0  with input as data.rds_instance_public_access_check.no_key
}

test_rds_instance_public_access_check_invalid {
    r := violations with input as data.rds_instance_public_access_check.invalid
    r[_]["finding"]["title"] = "RDS_INSTANCE_PUBLIC_ACCESS_CHECK"
    r[_]["finding"]["uid"] = "RDS-2"
}



