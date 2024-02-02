# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    ALB_DESYNC_MODE_CHECK
#
# Description:
#    Checks if an Application Load Balancer (ALB) is configured with a user defined desync mitigation mode.
#    The rule is NON_COMPLIANT if ALB desync mitigation mode does not match with the user defined desync mitigation mode.
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
package aws.elastic_load_balancing_v2.alb_desync_mode_check

import data.terraform.module as terraform
import data.utils as utils

import future.keywords

resource_type := "aws_lb"

title := "ALB_DESYNC_MODE_CHECK"

id := "ALB-1"

cust_id := "Bofa-AxiaMed"

owner := "UNKNOWN"

level := "HIGH"

checkAlbDesyncMode(mode) if {
	mode == ""
}

checkAlbDesyncMode(mode) if {
	data.variables.AlbDesyncModeCheckParamDesyncMode != []
	not mode in data.variables.AlbDesyncModeCheckParamDesyncMode
}

violations contains response if {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	mode := object.get(terraform.resources[j].values, "desync_mitigation_mode", "")
	checkAlbDesyncMode(mode)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) should be configured desync_mitigation_mode explicitly. Please set desync_mitigation_mode t one of the approved modes (%s) as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#desync_mitigation_mode",
				[terraform.resources[j].address, data.variables.AlbDesyncModeCheckParamDesyncMode],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.2.1, 1.3, 1.3.1, 1.3.2, 1.3.4, 2.2.3, 6.6"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
