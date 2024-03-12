# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    EC2_INSTANCE_NO_PUBLIC_IP
#
# Description:
#    Checks whether Amazon Elastic Compute Cloud (Amazon EC2) instances have a public IP association.
#    The rule is NON_COMPLIANT if the publicIp field is present in the Amazon EC2 instance configuration item. This rule applies only to IPv4.
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

package aws.amazon_ec2.ec2_instance_no_public_ip

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_instance"

title := "EC2_INSTANCE_NO_PUBLIC_IP"

level := "CRITICAL"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

violations[response] {
	level := "CRITICAL"
	id := "EC2-3"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	enis = object.get(terraform.resources[j].values, "network_interface", [])
	count(enis) > 0
	object.get(terraform.resources[j].values, "associate_public_ip_address", true)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource should not have a public IP. Please set associate_public_ip_address to false as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
