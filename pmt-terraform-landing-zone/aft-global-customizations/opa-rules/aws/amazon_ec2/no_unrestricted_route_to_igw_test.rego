package aws.amazon_ec2.no_unrestricted_route_to_igw

test_no_unrestricted_route_to_igw_route_valid {
	count(violations) == 0 with input as data.no_unrestricted_route_to_igw.route_valid
}

test_no_unrestricted_route_to_igw_route_no_gateway {
	count(violations) == 0 with input as data.no_unrestricted_route_to_igw.route_no_gateway
}

test_no_unrestricted_route_to_igw_route_route_no_gateway_open {
	count(violations) == 0 with input as data.no_unrestricted_route_to_igw.route_no_gateway_open
}

test_no_unrestricted_route_to_igw_route_no_gateway_ipv6_open {
	count(violations) == 0 with input as data.no_unrestricted_route_to_igw.route_no_gateway_ipv6_open
}

test_no_unrestricted_route_to_igw_route_gateway_ipv6_open {
	r := violations with input as data.no_unrestricted_route_to_igw.route_gateway_ipv6_open
	count(r) == 1
	r[_].finding.title = "NO_UNRESTRICTED_ROUTE_TO_IGW"
	r[_].finding.uid = "EC2-6"
}

test_no_unrestricted_route_to_igw_route_no_gateway_ipv4_open {
	r := violations with input as data.no_unrestricted_route_to_igw.route_no_gateway_ipv4_open
	count(r) == 1
	r[_].finding.title = "NO_UNRESTRICTED_ROUTE_TO_IGW"
	r[_].finding.uid = "EC2-6"
}

test_no_unrestricted_route_to_igw_route_no_gateway_route_table_valid {
	count(violations) == 0 with input as data.no_unrestricted_route_to_igw.route_table_valid
}

test_no_unrestricted_route_to_igw_route_table_invalid {
	r := violations with input as data.no_unrestricted_route_to_igw.route_table_invalid
	count(r) == 1
	r[_].finding.title = "NO_UNRESTRICTED_ROUTE_TO_IGW"
	r[_].finding.uid = "EC2-6"
}

test_no_unrestricted_route_to_igw_route_table_ipv4_invalid {
	r := violations with input as data.no_unrestricted_route_to_igw.route_table_ipv4_invalid
	count(r) == 1
	r[_].finding.title = "NO_UNRESTRICTED_ROUTE_TO_IGW"
	r[_].finding.uid = "EC2-6"
}

test_no_unrestricted_route_to_igw_route_table_ipv6_invalid {
	r := violations with input as data.no_unrestricted_route_to_igw.route_table_ipv6_invalid
	count(r) == 1
	r[_].finding.title = "NO_UNRESTRICTED_ROUTE_TO_IGW"
	r[_].finding.uid = "EC2-6"
}
