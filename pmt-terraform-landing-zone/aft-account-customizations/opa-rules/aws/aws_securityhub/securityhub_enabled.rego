# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   SECURITYHUB_ENABLED
#
# Description:
#    Checks that AWS Security Hub is enabled for an AWS Account.
#	 The rule is NON_COMPLIANT if AWS Security Hub is not enabled.
# Resource Types:
#    aws_securityhub_account
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.aws_securityhub.securityhub_enabled

import data.terraform.module as terraform
import data.utils as utils

# This is used for output and resource filtering (from mock data)
resource_type := "aws_securityhub_account"

title := "SECURITYHUB_ENABLED"

level := "HIGH"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

violations[response] {
	id := "SECURITYHUB-1"

	input.resource_changes[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(input.resource_changes[j], id, data.ignore_rules)

	action := object.get(input.resource_changes[j].change, "actions", "")
	action[0] == "delete"

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource Security Hub should remain enabled. A change has been detected which would disable AWS Security Hub. Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_account",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 11.5"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": input.resource_changes[j].type,
			"uid": input.resource_changes[j].address,
		},
	})
}
