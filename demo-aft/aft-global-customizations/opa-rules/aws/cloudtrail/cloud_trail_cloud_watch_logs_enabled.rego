# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    CLOUD_TRAIL_CLOUD_WATCH_LOGS_ENABLED
#
# Description:
#    Checks whether AWS CloudTrail trails are configured to send logs to Amazon CloudWatch logs.
#    The trail is non-compliant if the CloudWatchLogsLogGroupArn property of the trail is empty.
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
package aws.cloudtrail.cloud_trail_cloud_watch_logs_enabled

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_cloudtrail"

title := "CLOUD_TRAIL_CLOUD_WATCH_LOGS_ENABLED"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	id := "CLOUDTRAIL-1"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	object.get(terraform.resources[j].values, "cloud_watch_logs_group_arn", null) == null

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource (%s) should be integrated with CloudWatch Logs. Please define the cloud_watch_logs_group_arn attribute with the arn of the cloudwatch log group to send logs to as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 10.5.3"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
