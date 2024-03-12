# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    SUBNET_AUTO_ASSIGN_PUBLIC_IP_DISABLED
#
# Description:
#    Checks if Amazon Virtual Private Cloud (Amazon VPC) subnets are assigned a public IP address.
#    The rule is COMPLIANT if Amazon VPC does not have subnets that are assigned a public IP address.
#    The rule is NON_COMPLIANT if Amazon VPC has subnets that are assigned a public IP address.
#
# Resource Types:
#    aws_instance
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.amazon_ec2.subnet_auto_assign_public_ip_disabled

import data.terraform.module as terraform
import data.utils as utils

title := "SUBNET_AUTO_ASSIGN_PUBLIC_IP_DISABLED"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

resource_type := "aws_subnet"

violations[response] {
	id := "EC2-9"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	object.get(terraform.resources[j].values, "map_public_ip_on_launch", false)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource does not have map_public_ip_on_launch configured to true. Please configure map_public_ip_on_launch to false as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet#map_public_ip_on_launch",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
