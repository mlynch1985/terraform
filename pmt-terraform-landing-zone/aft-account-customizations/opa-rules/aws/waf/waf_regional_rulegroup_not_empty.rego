# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   WAF_REGIONAL_RULEGROUP_NOT_EMPTY
#
# Description:
#   Checks if WAF Regional rule groups contain any rules.
#   The rule is NON_COMPLIANT if there are no rules present within a WAF Regional rule group.
#
# Resource Types:
#    aws_wafregional_rule_group
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.waf.waf_regional_rulegroup_not_empty

import data.terraform.module as terraform
import data.utils as utils
import future.keywords.in

# This is used for output and resource filtering (from mock data)
resource_type := "aws_wafregional_rule_group"

title := "WAF_REGIONAL_RULEGROUP_NOT_EMPTY"

level := "CRITICAL"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

has_rule_associated(activated_rule) {
	activated_rule.rule_id.references == []
	terraform.resources[j].values.activated_rule == []
}

violations[response] {
	id := "WAF-2"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	confs := terraform.configurations[k]
	has_rule_associated(confs.expressions.activated_rule[i])

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource rule group must have rules in place. Please refer to this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafregional_rule_group",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 6.6"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
