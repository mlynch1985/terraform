# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   NETFW_POLICY_RULE_GROUP_ASSOCIATED
#
# Description:
#    "Check AWS Network Firewall policy is associated with stateful OR stateless rule groups.
#     This rule is NON_COMPLIANT if no stateful or stateless rule groups are associated with the Network Firewall policy
#     else COMPLIANT if any one of the rule group exists."
#
# Resource Types:
#    aws_networkfirewall_firewall_policy
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.network_firewall.netfw_policy_rule_group_associated

import data.terraform.module as terraform
import data.utils as utils

# This is used for output and resource filtering (from mock data)
resource_type := "aws_networkfirewall_firewall_policy"

title := "NETFW_POLICY_RULE_GROUP_ASSOCIATED"

id := "NETWORK_FIREWALL-1"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

stateful_or_stateless_not_empty(values) {
	either := any([
		count(values.stateful_rule_group_reference) != 0,
		count(values.stateless_rule_group_reference) != 0,
	])
	not either
}

violations[response] {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	stateful_or_stateless_not_empty(terraform.resources[j].values.firewall_policy[k])

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) is missing either a stateful or statless policy rule group. See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy for configuring this resource.",
				[terraform.resources[j].address],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 11.4, 1.3.6"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
