# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    IAM_POLICY_PASS_ROLE_CONDITIONS_CHECK
#
# Description:
# Evaluates an IAM Policy inspecting for statement blocks which one of several patterns of IAM:PassRole is granted.
# If the resource portion of the statement is * and no conditions statement exists this check will present a violation
#
# Resource Types:
#    iam
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.iam.iam_policy_pass_role_conditions_check

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

title := "IAM_POLICY_PASS_ROLE_CONDITIONS_CHECK"

level := "HIGH"

cust_id := "Bofa-AxiaMed"
owner := "UNKNOWN"

iam_resource_types = [
	"aws_iam_policy",
	"aws_iam_group_policy",
	"aws_iam_role_policy",
	"aws_iam_user_policy",
]

had_wildcard(resources) if {
	resources == "*"
}

had_wildcard(resources) if {
	resources[_] == "*"
}

# Evaluates an IAM Policy inspecting for statement blocks which one of several patterns of
# IAM:PassRole is granted.  If the resource portion of the statement is * and no conditions
# statement exists this check will present a violation.
violations contains response if {
	id := "IAM-4"

	utils.array_contains(iam_resource_types, terraform.resources[j].type)

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	policy := object.get(terraform.resources[j].values, "policy", {})
	policydoc := json.unmarshal(policy)
	statements := object.get(policydoc, "Statement", {})

	statement := statements[_]
	effect = object.get(statement, "Effect", "Deny")
	effect == "Allow"

	actions := object.get(statement, "Action", "")
	statementaction := actions[_]
	regex.template_match("iam:{PassRole|\\*|P\\*|P.*\\*}", statementaction, "{", "}")

	statementresources := object.get(statement, "Resource", "")
	had_wildcard(statementresources)

	not utils.has_key(statements, "Condition")

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": "Policies should not contain unrestrained passrole permissions. Define more specific permissions under actions",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1, 7.1.1, 7.1.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
