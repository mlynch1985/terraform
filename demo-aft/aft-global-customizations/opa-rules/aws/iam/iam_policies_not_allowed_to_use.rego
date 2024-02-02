# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    IAM_POLICIES_NOT_ALLOWED_TO_USE
#
# Description:
# Ensure IAM Principals are not using IAM policies that are not allowed by the organization.
#
# Resource Types:
#    "aws_iam_role","aws_iam_user"
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.iam.iam_policies_not_allowed_to_use

import data.terraform.module as terraform
import data.utils as utils

import future.keywords

level := "HIGH"

title := "IAM_POLICIES_NOT_ALLOWED_TO_USE"

cust_id := "Bofa-AxiaMed"
owner := "UNKNOWN"

iam_principal_types = [
	"aws_iam_role",
	"aws_iam_user",
]

violations contains response if {
	id := "IAM-1"

	utils.array_contains(iam_principal_types, terraform.resources[j].type)

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	utils.array_contains(data.variables.iam_policies_not_allowed, terraform.resources[j].values.managed_policy_arns[_])

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf("Non-recommended managed policies in use (%s).", [data.variables.iam_policies_not_allowed]),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1, 6.5.8"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
