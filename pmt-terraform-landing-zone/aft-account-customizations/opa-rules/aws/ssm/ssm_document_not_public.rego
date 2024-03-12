# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    SSM_DOCUMENT_NOT_PUBLIC
#
# Description:
#    Checks if Systems Manager document is public facing.
#    The rule is NON_COMPLIANT if permissions.account_ids == "All"
#
# Resource Types:
#    aws_ssm_document
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.ssm.ssm_document_not_public

import data.terraform.module as terraform
import data.utils as utils

# This is used for output and resource filtering (from mock data)
resource_type := "aws_ssm_document"

title := "SSM_DOCUMENT_NOT_PUBLIC"

id := "SSM-1"

level := "HIGH"

cust_id := "Bofa-AxiaMed"

owner := "UNKNOWN"

violations[response] {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	terraform.resources[j].values.permissions != null
	lower(terraform.resources[j].values.permissions.account_ids) == "all"

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) is public facing. Please configure Document permissions as detailed here https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document#permissions",
				[terraform.resources[j].address],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
