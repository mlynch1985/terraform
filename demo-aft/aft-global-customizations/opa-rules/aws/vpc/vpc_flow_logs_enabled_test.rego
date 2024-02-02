package aws.vpc.vpc_flow_logs_enabled

test_vpc_flow_logs_enabled_valid {
	count(violations) == 0 with input as data.vpc_flow_logs_enabled.valid
}

test_vpc_flow_logs_enabled_ignore {
	count(violations) == 0 with input as data.vpc_flow_logs_enabled.ignore
}

test_vpc_flow_logs_enabled_invalid {
	r := violations with input as data.vpc_flow_logs_enabled.invalid
	count(r) == 1
	r[_].finding.title = "VPC_FLOW_LOGS_ENABLED"
	r[_].finding.uid = "VPC-3"
}
