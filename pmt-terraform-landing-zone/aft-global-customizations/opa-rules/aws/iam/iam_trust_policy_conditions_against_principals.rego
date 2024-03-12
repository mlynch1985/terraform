# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    IAM_TRUST_POLICY_CONDITIONS_CHECK
#
# Description:
# aws_iam_policy - Evaluates an IAM Role trust policy inspecting for statement blocks which one of several patterns of
# STS:AssumeRole is granted.  If the principal portion of the statement is an account principal  for example
# (arn:aws:iam::123456789012:root) and no conditions are present this check will  present a violation
#
# Resource Types:
#   aws_iam_role, aws_iam_user
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.iam.iam_trust_policy_conditions_check

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

title := "IAM_TRUST_POLICY_CONDITIONS_CHECK"

level := "HIGH"

cust_id := "Bofa-AxiaMed"
owner := "UNKNOWN"

iam_principal_types = [
	"aws_iam_role",
	"aws_iam_user",
]

has_assumerole_action(actions) if {
	regex.template_match("sts:{AssumeRole|\\*|A\\*|A.*\\*}", actions[_], "{", "}")
}

has_assumerole_action(actions) if {
	regex.template_match("sts:{AssumeRole|\\*|A\\*|A.*\\*}", actions, "{", "}")
}

# Evaluates an IAM Role trust policy inspecting for statement blocks which one of several patterns of
# STS:AssumeRole is granted.  If the principal portion of the statement is an account principal
# for example (arn:aws:iam::123456789012:root) and no conditions are present this check will
# present a violation.
violations contains response if {
	id := "IAM-8"

	utils.array_contains(iam_principal_types, terraform.resources[j].type)

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	assume_role_policy := object.get(terraform.resources[j].values, "assume_role_policy", {})
	policydoc := json.unmarshal(assume_role_policy)
	statements := object.get(policydoc, "Statement", {})

	statement := statements[_]
	statement_effect = object.get(statement, "Effect", "Allow")
	statement_actions := object.get(statement, "Action", "")
	statement_resources := object.get(statement, "Resource", "")
	statement_conditions := object.get(statement, "Condition", [])
	statement_principals := object.get(statement, "Principal", [])

	statement_effect == "Allow"
	has_assumerole_action(statement_actions)
	utils.has_key(statement_principals, "AWS")
	regex.template_match("arn:aws:iam::{.*}:root", statement_principals.AWS, "{", "}")
	count(statement_conditions) == 0

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": "Trust policies should not contain unrestrained AssumeRole permissions to an account principal without conditions. Implement a condition such as aws:PrincipalOrgID to restrict access to expected principals to those in an expected organization.",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1, 7.1.1, 7.1.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
