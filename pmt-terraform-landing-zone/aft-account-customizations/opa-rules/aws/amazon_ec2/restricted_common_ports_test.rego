package aws.amazon_ec2.restricted_common_ports


test_restricted_common_ports_sg_valid {
    count(violations) == 0  with input as data.restricted_common_ports.sg_valid
}


test_restricted_common_ports_ignore {
    count(violations) == 0  with input as data.restricted_common_ports.ignore
}

test_restricted_common_ports_sg_invalid {
    r := violations with input as data.restricted_common_ports.sg_invalid
    count(r) == 1
    r[_]["finding"]["title"] = "RESTRICTED_INCOMING_TRAFFIC"
    r[_]["finding"]["uid"] = "EC2-7"
}

test_restricted_common_ports_sgr_valid {
    count(violations) == 0  with input as data.restricted_common_ports.sgr_valid
}

test_restricted_common_ports_sgr_egress {
    count(violations) == 0  with input as data.restricted_common_ports.sgr_egress
}

test_restricted_common_ports_sgr_invalid {
    r := violations with input as data.restricted_common_ports.sgr_invalid
    count(r) == 1
    r[_]["finding"]["title"] = "RESTRICTED_INCOMING_TRAFFIC"
    r[_]["finding"]["uid"] = "EC2-7"
}



