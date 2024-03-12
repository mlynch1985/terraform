# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   NETFW_STATELESS_RULE_GROUP_NOT_EMPTY
#
# Description:
#    "Checks if a Stateless Network Firewall Rule Group contains rules.
#     The rule is NON_COMPLIANT if there are no rules in a Stateless Network Firewall Rule Group."
#
# Resource Types:
#    aws_networkfirewall_rule_group
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.network_firewall.netfw_stateless_rule_group_not_empty

import data.terraform.module as terraform
import data.utils as utils

# This is used for output and resource filtering (from mock data)
resource_type := "aws_networkfirewall_rule_group"

title := "NETFW_STATELESS_RULE_GROUP_NOT_EMPTY"

id := "NETWORK_FIREWALL-2"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

empty_rule := [{
	"destination": [],
	"destination_port": [],
	"protocols": [],
	"source": [],
	"source_port": [],
	"tcp_flag": [],
}]

found_empty_rule(values) {
	values.match_attributes == empty_rule
}

violations[response] {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	found_empty_rule(terraform.resources[j].values.rule_group[_].rules_source[_].stateless_rules_and_custom_actions[_].stateless_rule[_].rule_definition[_])

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) at least one of your stateless_rule(s) is missing match attributes: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group ",
				[terraform.resources[j].address],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
