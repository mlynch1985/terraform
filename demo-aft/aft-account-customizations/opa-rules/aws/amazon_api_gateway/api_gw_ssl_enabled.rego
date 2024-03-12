# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   API_GW_SSL_ENABLED
#
# Description:
#     Checks if a REST API stage uses an SSL certificate.
#     The rule is NON_COMPLIANT if the REST API stage does not have an associated SSL certificate.
# Resource Types:
#    aws_api_gateway_stage
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_api_gateway.api_gw_ssl_enabled

import data.terraform.module as terraform
import data.utils as utils

# This is used for output and resource filtering (from mock data)
resource_type := "aws_api_gateway_stage"

title := "API_GW_SSL_ENABLED"

id := "AMAZON_API_GATEWAY-1"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	input.configuration.root_module.resources[i].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(input.configuration.root_module.resources[i], id, data.ignore_rules)

	object.get(input.configuration.root_module.resources[i].expressions, "client_certificate_id", 0) == 0

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": input.configuration.root_module.resources[i].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"Description": sprintf(
				"Resource (%s) REST API gateway stage does not have an associated SSL certificate. The \"client_certificate_id =\" argument should exist and reference a resource within the template or the ID of an existing cert. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage ",
				[input.configuration.root_module.resources[i].address],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.3, 4.1, 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": input.configuration.root_module.resources[i].type,
			"uid": input.configuration.root_module.resources[i].address,
		},
	})
}
