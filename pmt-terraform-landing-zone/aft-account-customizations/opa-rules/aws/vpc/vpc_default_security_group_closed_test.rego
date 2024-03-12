package aws.vpc.vpc_default_security_group_closed

test_vpc_default_security_group_closed_valid {
	count(violations) == 0 with input as data.vpc_default_security_group_closed.valid
}

test_vpc_default_security_group_closed_ignore {
	count(violations) == 0 with input as data.vpc_default_security_group_closed.ignore
}

test_vpc_default_security_group_closed_invalid {
	r := violations with input as data.vpc_default_security_group_closed.invalid
	count(r) == 1
	r[_].finding.title = "VPC_DEFAULT_SECURITY_GROUP_CLOSED"
	r[_].finding.uid = "VPC-1"
}
