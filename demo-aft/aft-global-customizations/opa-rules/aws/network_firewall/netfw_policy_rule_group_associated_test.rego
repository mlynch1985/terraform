package aws.network_firewall.netfw_policy_rule_group_associated

test_netfw_policy_rule_group_associated_stateless_valid {
	count(violations) == 0 with input as data.netfw_policy_rule_group_associated.valid0
}

test_netfw_policy_rule_group_associated_stateful_valid {
	count(violations) == 0 with input as data.netfw_policy_rule_group_associated.valid1
}

test_netfw_policy_rule_group_associated_stateful_valid {
	count(violations) == 0 with input as data.netfw_policy_rule_group_associated.valid2
}

test_netfw_policy_rule_group_associated_ignore {
	count(violations) == 0 with input as data.netfw_policy_rule_group_associated.ignore
}

test_netfw_policy_rule_group_associated_invalid {
	r := violations with input as data.netfw_policy_rule_group_associated.invalid
	count(r) == 1
	r[_].finding.title = "NETFW_POLICY_RULE_GROUP_ASSOCIATED"
	r[_].finding.uid = "NETWORK_FIREWALL-1"
}
