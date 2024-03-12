# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   VPC_DEFAULT_SECURITY_GROUP_CLOSED
#
# Description:
#    "Checks if the default security group of any Amazon Virtual Private Cloud (VPC) does not allow inbound or outbound traffic."
#
# Resource Types:
#    aws_default_security_group
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.vpc.vpc_default_security_group_closed

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

# This is used for output and resource filtering (from mock data)
resource_type := "aws_default_security_group"

title := "VPC_DEFAULT_SECURITY_GROUP_CLOSED"

id := "VPC-1"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

ingress_egress_missing if {
	vals := terraform.resources[j].values
	all([
		object.get(vals, "ingress", true),
		object.get(vals, "egress", true),
	])
}

violations contains response if {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not ingress_egress_missing

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) the default vpc security group must not have any ingress or egress rules. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group#example-usage",
			[id, level, terraform.resources[j].address],
		),
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 2.1, 2.2, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
