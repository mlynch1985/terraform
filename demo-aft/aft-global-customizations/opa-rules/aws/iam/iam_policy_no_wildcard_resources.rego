# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    IAM_POLICY_NO_WILDCARD_RESOURCES
#
# Description:
# IAM policies should restrict permissions to specific resources, should not contain a wildcard "*" for resources without
# condition statements. Does not apply to resource base policies
#
# Resource Types:
#    aws_iam_policy, aws_iam_group_policy, aws_iam_role_policy, aws_iam_user_policy
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.iam.iam_policy_no_wildcard_resources

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

id := "IAM-3"

title := "IAM_POLICY_NO_WILDCARD_RESOURCES"

level := "HIGH"

cust_id := "TBD"
owner := "TBD"

iam_resource_types := [
	"aws_iam_policy",
	"aws_iam_group_policy",
	"aws_iam_role_policy",
	"aws_iam_user_policy",
	"aws_iam_role",
]

had_wildcard(resources) if {
	resources == "*"
}

had_wildcard(resources) if {
	resources[_] == "*"
}

is_policy_invalid(policy_json) if {
	statements := object.get(policy_json, "Statement", {})

	statement := statements[k]
	policy_resources := object.get(statement, "Resource", "")
	conditions := object.get(statement, "Condition", [])
	principals := object.get(statement, "Principal", [])

	had_wildcard(policy_resources)
	count(principals) == 0
	count(conditions) == 0
}

violations contains response if {
	terraform.resources[j].type in iam_resource_types

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	policy := object.get(terraform.resources[j].values, "policy", {})

	policy_json := json.unmarshal(policy)
	is_policy_invalid(policy_json)

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) is a identity-based policy and should not allow * in resource section without condition statement. Please provide a list of specific resources or a condition statement to tighten scope",
			[id, level, terraform.resources[j].address],
		),
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1, 7.1.1, 7.1.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

violations contains response if {
	terraform.resources[j].type == "aws_iam_role"

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	policy := object.get(terraform.resources[j].values, "assume_role_policy", {})
	policy_json := json.unmarshal(policy)

	is_policy_invalid(policy_json)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": "Resource is a identity-based policy and should not allow * in resource section without condition statement. Please provide a list of specific resources or a condition statement to tighten scope",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1, 7.1.1, 7.1.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

violations contains response if {
	terraform.resources[j].type == "aws_iam_role"

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	inline_policy := object.get(terraform.resources[j].values, "inline_policy", [])
	policy_json := json.unmarshal(object.get(inline_policy[k], "policy", {}))

	is_policy_invalid(policy_json)

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) is a identity-based policy and should not allow * in resource section without condition statement. Please provide a list of specific resources or a condition statement to tighten scope",
			[id, level, terraform.resources[j].address],
		),
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1, 7.1.1, 7.1.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
