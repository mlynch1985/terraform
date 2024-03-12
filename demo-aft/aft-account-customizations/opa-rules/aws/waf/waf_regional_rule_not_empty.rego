# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   WAF_REGIONAL_RULE_NOT_EMPTY
#
# Description:
#   Checks whether WAF regional rule contains conditions.
#   This rule is COMPLIANT if the regional rule contains at least one condition and NON_COMPLIANT otherwise.
# Resource Types:
#    aws_wafregional_rule
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.waf.waf_regional_rule_not_empty

import data.terraform.module as terraform
import data.utils as utils
import future.keywords.in

# This is used for output and resource filtering (from mock data)
resource_type := "aws_wafregional_rule"

title := "WAF_REGIONAL_RULE_NOT_EMPTY"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	id := "WAF-4"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	count(terraform.resources[j].values.predicate) == 0

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource rule must have a condition defined through the predicate argument. Please refer to this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafregional_rule#predicate",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 6.6"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
