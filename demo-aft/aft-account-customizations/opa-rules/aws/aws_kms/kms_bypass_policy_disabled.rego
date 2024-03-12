# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    KMS_BYPASS_POLICY_DISABLED
#
# Description:
#    Checks if the KMS Bypass policy is enabled
#    The rule is NON_COMPLIANT if any KMS key has parameter bypass_policy_lockout_safety_check is set to true.
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

package aws.aws_kms.kms_bypass_policy_disabled

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_kms_key"

title := "KMS_BYPASS_POLICY_DISABLED"

level := "CRITICAL"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	id := "KMS-4"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	object.get(terraform.resources[j].values, "bypass_policy_lockout_safety_check", false)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) bypass the key policy lockout safety check should be disabled. Please set bypass_policy_lockout_safety_check to false as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#bypass_policy_lockout_safety_check",
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
