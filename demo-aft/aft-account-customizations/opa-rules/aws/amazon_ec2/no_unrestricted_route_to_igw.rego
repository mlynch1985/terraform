# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    NO_UNRESTRICTED_ROUTE_TO_IGW
#
# Description:
#    Checks if there are public routes in the route table to an Internet Gateway (IGW).
#    The rule is NON_COMPLIANT if a route to an IGW has a destination CIDR block of '0.0.0.0/0' or '::/0' or if a destination CIDR block does not match the rule parameter.
#
# Resource Types:
#    aws_route, aws_route_table
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.amazon_ec2.no_unrestricted_route_to_igw

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

level := "HIGH"

title := "NO_UNRESTRICTED_ROUTE_TO_IGW"

cust_id := "TBD"

owner := "TBD"

resource_type := ["aws_route", "aws_route_table"]

open_cidr := {
	"cidr_block": "0.0.0.0/0",
	"ipv6_cidr_block": "::/0",
	"destination_cidr_block": "0.0.0.0/0",
	"destination_ipv6_cidr_block": "::/0",
}

violations contains response if {
	level := "HIGH"
	id := "EC2-6"

	terraform.resources[j].type == "aws_route"

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not utils.empty_or_null(object.get(terraform.resources[j].values, "gateway_id", null))
	terraform.resources[j].values[_] in open_cidr

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource Routes to an IGW cannot have a destination CIDR block of '0.0.0.0/0' or '::/0'. Please configure as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.4, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

violations contains response if {
	level := "HIGH"
	id := "EC2-6"

	terraform.resources[j].type == "aws_route_table"

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not object.get(terraform.resources[j].values.route[k], "gateway_id", "") in [null, ""]
	terraform.resources[j].values.route[k][_] == open_cidr[_]

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource Routes to an IGW cannot have a destination CIDR block of '0.0.0.0/0' or '::/0'. Please configure as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.4, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
