# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    MULTI_REGION_CLOUD_TRAIL_ENABLED
#
# Description:
#    Checks if there is at least one multi-region AWS CloudTrail. The rule is NON_COMPLIANT if the trails do not match input parameters.
#    The rule is NON_COMPLIANT if the ExcludeManagementEventSources field is not empty or if AWS CloudTrail is configured to exclude management events such as AWS KMS events or Amazon RDS Data API events.
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

package aws.cloudtrail.multi_region_cloud_trail_enabled

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_cloudtrail"

title := "MULTI_REGION_CLOUD_TRAIL_ENABLED"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	id := "CLOUDTRAIL-6"
	terraform.resources[j].type == "aws_cloudtrail"

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not object.get(terraform.resources[j].values, "is_multi_region_trail", false)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource should set to log multiple regions. Please configure is_multi_region_trail as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 10.1, 10.2.1, 10.2.2, 10.2.3, 10.2.4, 10.2.5, 10.2.6, 10.2.7, 10.3.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
