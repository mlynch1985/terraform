# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    EC2_INSTANCE_MULTIPLE_ENI_CHECK
#
# Description:
#    Checks if Amazon Elastic Compute Cloud (Amazon EC2) uses multiple ENIs (Elastic Network Interfaces) or Elastic Fabric Adapters (EFAs).
#    This rule is NON_COMPLIANT an Amazon EC2 instance use multiple network interfaces.
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

package aws.amazon_ec2.ec2_instance_multiple_eni_check

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_instance"

title := "EC2_INSTANCE_MULTIPLE_ENI_CHECK"

level := "HIGH"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

violations[response] {
	id := "EC2-2"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	enis = object.get(terraform.resources[j].values, "network_interface", [])
	count(enis) > 1

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource should not have multiple enis attached. Please configure network_interface as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#network_interface",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
