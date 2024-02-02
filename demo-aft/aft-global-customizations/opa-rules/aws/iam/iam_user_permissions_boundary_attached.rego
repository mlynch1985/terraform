# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    IAM_USER_PERMISSIONS_BOUNDARY_ATTACHED
#
# Description:
# aws_iam_user - IAM Principals should have a permissions boundary attached
#
# Resource Types:
#    aws_iam_user
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.iam.iam_user_permissions_boundary_attached

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

title := "IAM_USER_PERMISSIONS_BOUNDARY_ATTACHED"

level := "HIGH"

cust_id := "Bofa-AxiaMed"
owner := "UNKNOWN"

iam_resource_types = ["aws_iam_user"]

violations contains response if {
	id := "IAM-7"

	terraform.resources[j].type in iam_resource_types

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	terraform.resources[j].values.permissions_boundary == null

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": "IAM Principals should have a permissions boundary attached",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1.1, 7.1.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
