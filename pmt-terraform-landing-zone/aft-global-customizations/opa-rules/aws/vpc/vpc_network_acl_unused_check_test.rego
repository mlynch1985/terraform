package aws.vpc.vpc_network_acl_unused_check

test_vpc_network_acl_unused_check_valid {
	count(violations) == 0 with input as data.vpc_network_acl_unused_check.valid
}

test_vpc_network_acl_unused_check_ignore {
	count(violations) == 0 with input as data.vpc_network_acl_unused_check.ignore
}

test_vpc_network_acl_unused_check_invalid {
	r := violations with input as data.vpc_network_acl_unused_check.invalid
	count(r) == 1
	r[_].finding.title = "VPC_NETWORK_ACL_UNUSED_CHECK"
	r[_].finding.uid = "VPC-4"
}
