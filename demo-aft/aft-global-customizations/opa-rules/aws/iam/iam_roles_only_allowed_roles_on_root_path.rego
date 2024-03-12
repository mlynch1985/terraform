# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    IAM_ROLES_ONLY_CORE_ROLES_ALLOWED_ON_ROOT_PATH
#
# Description:
# Ensure IAM Actions are restricted to only those actions that are needed.
# Allowing users to have more privileges than needed to complete a task may violate the principle of least privilege and separation of duties.
#
# Resource Types:
#    aws_iam_role
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.iam.iam_roles_only_allowed_roles_on_root_path

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

title := "IAM_ROLES_ONLY_CORE_ROLES_ALLOWED_ON_ROOT_PATH"

level := "HIGH"

cust_id := "TBD"
owner := "TBD"

violations contains response if {
	id := "IAM-6"

	terraform.resources[j].type == "aws_iam_role"

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	terraform.resources[j].values.path == "/"
	not utils.array_contains(data.variables.core_iam_roles, terraform.resources[j].name)


	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": "Only Core Infrastructure Roles should be placed on the root path",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1, 7.1.1, 7.1.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
