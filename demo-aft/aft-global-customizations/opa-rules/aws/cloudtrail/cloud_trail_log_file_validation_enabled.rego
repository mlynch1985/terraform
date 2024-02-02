# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    CLOUD_TRAIL_LOG_FILE_VALIDATION_ENABLED
#
# Description:
#    Checks whether AWS CloudTrail creates a signed digest file with logs.
#    AWS recommends that the file validation must be enabled on all trails.
#    The rule is noncompliant if the validation is not enabled.
#
# Resource Types:
#    aws_cloudtrail
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.cloudtrail.cloud_trail_log_file_validation_enabled

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_cloudtrail"

title := "CLOUD_TRAIL_LOG_FILE_VALIDATION_ENABLED"

id := "CLOUDTRAIL-3"

level := "HIGH"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

violations[response] {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not object.get(terraform.resources[j].values, "enable_log_file_validation", false)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource log file validation should be enabled. Please set enable_log_file_validation to true as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 10.5.5, 11.5"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
