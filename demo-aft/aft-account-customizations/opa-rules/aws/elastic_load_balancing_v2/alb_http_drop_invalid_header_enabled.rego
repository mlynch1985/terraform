# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    ALB_HTTP_DROP_INVALID_HEADER_ENABLED
#
# Description:
#    Checks if rule evaluates AWS Application Load Balancers (ALB) to ensure they are configured to drop http headers.
#    The rule is NON_COMPLIANT if the value of routing.http.drop_invalid_header_fields.enabled is set to false.
#
# Resource Types:
#    aws_lb
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.elastic_load_balancing_v2.alb_http_drop_invalid_header_enabled

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_lb"

title := "ALB_HTTP_DROP_INVALID_HEADER_ENABLED"

id := "ALB-2"

cust_id := "TBD"

owner := "TBD"

level := "HIGH"

violations[response] {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not object.get(terraform.resources[j].values, "drop_invalid_header_fields", false)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) should be configured to drop HTTP headers. Please set drop_invalid_header_fields to true as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb",
				[terraform.resources[j].address],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.2.1, 1.3, 1.3.1, 1.3.2, 1.3.4"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
