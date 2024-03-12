package aws.vpc.vpc_sg_open_only_to_authorized_ports

test_vpc_sg_open_only_to_authorized_ports_check_valid_tcp {
	count(violations) == 0 with input as data.vpc_sg_open_only_to_authorized_ports.valid_tcp
}

test_vpc_sg_open_only_to_authorized_ports_check_valid_port_range_tcp {
	count(violations) == 0 with input as data.vpc_sg_open_only_to_authorized_ports.valid_port_range_tcp
}

test_vpc_sg_open_only_to_authorized_ports_check_no_ingress {
	count(violations) == 0 with input as data.vpc_sg_open_only_to_authorized_ports.no_ingress
}

test_vpc_sg_open_only_to_authorized_ports_check_ignore {
	count(violations) == 0 with input as data.vpc_sg_open_only_to_authorized_ports.ignore
}

test_vpc_sg_open_only_to_authorized_ports_check_both_valid_port_range_tcp {
	count(violations) == 0 with input as data.vpc_sg_open_only_to_authorized_ports.both_valid_port_range_tcp
}

test_vpc_sg_open_only_to_authorized_ports_check_valid_udp {
	count(violations) == 0 with input as data.vpc_sg_open_only_to_authorized_ports.valid_tcp
}

test_vpc_sg_open_only_to_authorized_ports_check_valid_port_range_udp {
	count(violations) == 0 with input as data.vpc_sg_open_only_to_authorized_ports.valid_port_range_udp
}

test_vpc_sg_open_only_to_authorized_ports_check_both_valid_port_range_udp {
	count(violations) == 0 with input as data.vpc_sg_open_only_to_authorized_ports.both_valid_port_range_udp
}

test_vpc_sg_open_only_to_authorized_ports_check_invalid {
	r := violations with input as data.vpc_sg_open_only_to_authorized_ports.invalid_tcp
	count(r) == 1
	r[_].finding.title = "VPC_SG_OPEN_ONLY_TO_AUTHORIZED_PORTS"
	r[_].finding.uid = "VPC-2"
}
