package aws.network_firewall.netfw_stateless_rule_group_not_empty

test_netfw_stateless_rule_group_not_empty_valid {
	count(violations) == 0 with input as data.netfw_stateless_rule_group_not_empty.valid
}

test_netfw_stateless_rule_group_not_empty_ignore {
	count(violations) == 0 with input as data.netfw_stateless_rule_group_not_empty.ignore
}

test_netfw_stateless_rule_group_not_empty_invalid {
	r := violations with input as data.netfw_stateless_rule_group_not_empty.invalid
	count(r) == 1
	r[_].finding.title = "NETFW_STATELESS_RULE_GROUP_NOT_EMPTY"
	r[_].finding.uid = "NETWORK_FIREWALL-2"
}
