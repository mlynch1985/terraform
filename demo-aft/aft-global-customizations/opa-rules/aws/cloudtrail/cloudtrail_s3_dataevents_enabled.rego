# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    CLOUDTRAIL_S3_DATAEVENTS_ENABLED
#
# Description:
#    Checks if Amazon SNS topic is encrypted with AWS Key Management Service (AWS KMS).
#    The rule is NON_COMPLIANT if the Amazon SNS topic is not encrypted with AWS KMS. The rule is also NON_COMPLIANT when encrypted KMS key is not present in kmsKeyIds input parameter.
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

package aws.cloudtrail.cloudtrail_s3_dataevents_enabled

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_cloudtrail"

title := "CLOUDTRAIL_S3_DATAEVENTS_ENABLED"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

check_events(res) {
	object.get(res, "event_selector", []) == []
} else {
	pass := {n |
		n := res.event_selector[_]
		n.data_resource[_].type == "AWS::S3::Object"
		n.data_resource[_].values[_] == "arn:aws:s3"
		n.read_write_type == "All"
		n.include_management_events
	}
	count(pass) == 0
}

violations[response] {
	id := "CLOUDTRAIL-5"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	check_events(terraform.resources[j].values)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource should have data events being logged. Please configure event_selector as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail#event_selector",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 10.1, 10.2.1, 10.2.3, 10.2.4, 10.3.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
