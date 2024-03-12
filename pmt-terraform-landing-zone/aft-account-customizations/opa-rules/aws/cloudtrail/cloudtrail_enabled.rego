# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    CLOUD_TRAIL_ENABLED
#
# Description:
#    Checks if an AWS CloudTrail trail is enabled in your AWS account.
#    The rule is NON_COMPLIANT if a trail is not enabled. You can specify for the rule to check a specific S3 bucket, SNS topic, and Amazon CloudWatch log group.
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

package aws.cloudtrail.cloudtrail_enabled

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_cloudtrail"

title := "CLOUD_TRAIL_ENABLED"

level := "CRITICAL"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

is_cloudtrail_disabled(values) {
	actions := object.get(values.resource_changes[j].change, "actions", "")
	utils.array_contains(actions, "delete")
} else {
	after := object.get(values.resource_changes[j].change, "after", "")
	enabled := object.get(after, "enable_logging", false)
	enabled == false
}

violations[response] {
	id := "CLOUDTRAIL-4"

	input.resource_changes[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(input.resource_changes[j], id, data.ignore_rules)

	is_cloudtrail_disabled(input)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource is attempting to disable or delete the CloudTrail trail which is not allowed by your organization. Please contact your security/cloud/platform engineering team if you really need to turn off CloudTrail logging. Refer to terraform documentation on other arguments that can be modified https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 10.1, 10.2.1, 10.2.2, 10.2.3, 10.2.4, 10.2.5, 10.2.6, 10.2.7, 10.3.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": input.resource_changes[j].type,
			"uid": input.resource_changes[j].address,
		},
	})
}
