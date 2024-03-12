# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    ELB_TLS_HTTPS_LISTENERS_ONLY
#
# Description:
#    If the Classic Load Balancer does not have a listener configured, then the rule returns NOT_APPLICABLE.
#    The rule is COMPLIANT if the Classic Load Balancer listeners are configured with SSL or HTTPS.
#    The rule is NON_COMPLIANT if a listener is not configured with SSL or HTTPS.
#
# Resource Types:
#    aws_elb
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.elastic_load_balancing.elb_tls_https_listeners_only

import data.terraform.module as terraform
import data.utils as utils

import future.keywords

resource_type := "aws_elb"

title := "ELB_TLS_HTTPS_LISTENERS_ONLY"

id := "ELB-2"

cust_id := "Bofa-AxiaMed"

owner := "UNKNOWN"

level := "CRITICAL"

violations contains response if {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not lower(terraform.resources[j].values.listener[_].lb_protocol) in ["https", "ssl"]

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) should be configured with HTTPS or SSL termination. Please add or edit listener block to include https or ssl protocol as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb",
				[terraform.resources[j].address],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.3, 4.1, 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
