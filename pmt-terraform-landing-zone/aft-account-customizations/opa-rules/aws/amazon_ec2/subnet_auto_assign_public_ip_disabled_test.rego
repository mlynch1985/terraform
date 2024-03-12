package aws.amazon_ec2.subnet_auto_assign_public_ip_disabled

test_subnet_auto_assign_public_ip_disabled_valid {
	count(violations) == 0 with input as data.subnet_auto_assign_public_ip_disabled.valid
}

test_subnet_auto_assign_public_ip_disabled_ignore {
	count(violations) == 0 with input as data.subnet_auto_assign_public_ip_disabled.ignore
}

test_subnet_auto_assign_public_ip_disabled_invalid {
	r := violations with input as data.subnet_auto_assign_public_ip_disabled.invalid
	count(r) == 1
	r[_].finding.title = "SUBNET_AUTO_ASSIGN_PUBLIC_IP_DISABLED"
	r[_].finding.uid = "EC2-9"
}

test_subnet_auto_assign_public_ip_disabled_no_key {
	count(violations) == 0 with input as data.subnet_auto_assign_public_ip_disabled.no_key
}
