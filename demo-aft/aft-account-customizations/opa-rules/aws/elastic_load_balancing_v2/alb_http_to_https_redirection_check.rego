# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    ALB_HTTP_TO_HTTPS_REDIRECTION_CHECK
#
# Description:
#    Checks if HTTP to HTTPS redirection is configured on all HTTP listeners of Application Load Balancers.
#    The rule is NON_COMPLIANT if one or more HTTP listeners of Application Load Balancer do not have HTTP to HTTPS redirection configured.
#    The rule is also NON_COMPLIANT if one of more HTTP listeners have forwarding to an HTTP listener instead of redirection.
#
# Resource Types:
#    aws_lb_listener
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.elastic_load_balancing_v2.alb_http_to_https_redirection_check

import data.terraform.module as terraform
import data.utils as utils

import future.keywords

title := "ALB_HTTP_TO_HTTPS_REDIRECTION_CHECK"

id := "ALB-3"

resource_type := "aws_lb_listener"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

violations contains response if {
	terraform.resources[j].type == "aws_lb_listener"

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	terraform.resources[j].values.protocol == "HTTP"
	terraform.resources[j].values.default_action[_].type == "redirect"
	is_redirect = {v |
		v := terraform.resources[j].values.default_action[_].redirect[_].protocol
	}
	not "HTTPS" in is_redirect

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) should be redirect to HTTPS. Please set default_action to redirect and port to HTTPS as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#redirect",
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

violations contains response if {
	terraform.resources[j].type == "aws_lb_listener"

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	terraform.resources[j].values.protocol == "HTTP"
	terraform.resources[j].values.default_action[_].type == "forward"

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) should not set default_action to forward. Please set default_action to redirect and port to HTTPS as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#redirect",
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
