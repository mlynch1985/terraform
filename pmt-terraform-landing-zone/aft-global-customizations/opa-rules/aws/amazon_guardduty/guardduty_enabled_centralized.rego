# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   GUARDDUTY_ENABLED_CENTRALIZED
#
# Description:
#    Checks if Amazon GuardDuty is being disabled.
#    Note: Does not check for centralized GuardDuty account.  That is handled via separate TF resource.
#
# Resource Types:
#    aws_guardduty_detector
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_guardduty.guardduty_enabled_centralized

import data.terraform.module as terraform
import data.utils as utils

# This is used for output and resource filtering (from mock data)
resource_type := "aws_guardduty_detector"

title := "GUARDDUTY_ENABLED_CENTRALIZED"

id := "AMAZON_GUARDDUTY-1"

level := "HIGH"

cust_id := "Bofa-AxiaMed"

owner := "UNKNOWN"

is_guardduty_disabled(values) {
	actions := object.get(values.resource_changes[j].change, "actions", "")
	utils.array_contains(actions, "delete")
} else {
	after := object.get(values.resource_changes[j].change, "after", "")
	enabled := object.get(after, "enable", false)
	enabled == false
}

violations[response] {
	input.resource_changes[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(input.resource_changes[j], id, data.ignore_rules)

	is_guardduty_disabled(input)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": input.resource_changes[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) is attempting to disable or delete the Amazon GuardDuty detector which is not allowed. Refer to terraform documentation on how prevent disable or deleting the detector. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector",
				[input.resource_changes[j].address],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 11.4"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": input.resource_changes[j].type,
			"uid": input.resource_changes[j].address,
		},
	})
}
