# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   VPC_FLOW_LOGS_ENABLED
#
# Description:
#    "Checks whether Amazon Virtual Private Cloud flow logs are found and enabled for Amazon VPC."
#
# Resource Types:
#	aws_vpc
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.vpc.vpc_flow_logs_enabled

import data.terraform.module as terraform
import data.utils as utils
import future.keywords.in

# This is used for output and resource filtering (from mock data)
resource_type := "aws_vpc"

level := "HIGH"

title := "VPC_FLOW_LOGS_ENABLED"

id := "VPC-3"

cust_id := "TBD"

owner := "TBD"

has_vpc_and_flowlog {
	# must contain both aws_vpc and aws_flow_log resource types to qualify
	types := [x | x := object.get(terraform.resources[j], "type", [])]
	all([utils.array_contains(types, "aws_vpc"), utils.array_contains(types, "aws_flow_log")])
}

ref_vpc {
	# vpc_flow_log configuration must reference aws_vpc resource
	has_vpc_and_flowlog
	confs := terraform.configurations[j]
	res := terraform.resources[x]
	utils.array_contains(confs.expressions.vpc_id.references, res.address)
}

violations[response] {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not ref_vpc

	response := terraform.ocsf_response(id, title, {
    "message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) VPC Flow logs must be enabled and attached to a vpc_id. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log",
				[terraform.resources[j].address],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 10.1, 10.3.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
