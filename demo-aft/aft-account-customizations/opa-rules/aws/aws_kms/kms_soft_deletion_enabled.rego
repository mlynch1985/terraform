# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    KMS_SOFT_DELETION_ENABLED
#
# Description:
#	 Checks whether KMS key that is set for deletion has soft deletion enabled
#    The rule is NON_COMPLIANT if any KMS key parameter deletion_window_in_days is not set to 30 days.
#
# Resource Types:
#    aws_kms_key
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
# deletion_window_in_days
package aws.aws_kms.kms_soft_deletion_enabled

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_kms_key"

title := "KMS_SOFT_DELETION_ENABLED"

level := "CRITICAL"

cust_id := "TBD"

owner := "TBD"

days_to_delete := 30

soft_delete_enabled(values) {
	object.get(values, "deletion_window_in_days", 30) == days_to_delete
}

soft_delete_enabled(values) {
	object.get(values, "deletion_window_in_days", 30) == null
}

violations[response] {
	id := "KMS-5"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not soft_delete_enabled(terraform.resources[j].values)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) should have soft deletion enabled. Please set deletion_window_in_days to 30 as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#deletion_window_in_days",
				[terraform.resources[j].address],
			),
		},
		"compliance": {"requirements": ["NIST 800-53"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
