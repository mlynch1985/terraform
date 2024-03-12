# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    IAM_NO_INLINE_POLICIES_CHECK
#
# Description:
# Ensure an AWS Identity and Access Management (IAM) user, IAM role or IAM group does not have an inline policy to control access to systems and assets.
# AWS recommends to use managed policies instead of inline policies. The managed policies allow reusability, versioning and rolling back, and delegating permissions management.
#
# Resource Types:
#    aws_iam_user_policy or aws_iam_role_policy or aws_iam_group_policy
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.iam.iam_no_inline_policies_check

import data.terraform.module as terraform
import data.utils as utils

import future.keywords

level := "HIGH"

title := "IAM_NO_INLINE_POLICIES_CHECK"

cust_id := "TBD"

owner := "TBD"

iam_principal_types = [
	"aws_iam_user_policy",
	"aws_iam_role_policy",
	"aws_iam_group_policy"
]

violations contains response if {
	id := "IAM-10"

	utils.array_contains(iam_principal_types, terraform.resources[j].type)

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": "Assigning privileges at the user, group or the role level, instead of via inline policies, helps to reduce opportunity for an identity to receive or retain excessive privileges.",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 7.1.1, 7.1.2, 7.2.1, 7.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
