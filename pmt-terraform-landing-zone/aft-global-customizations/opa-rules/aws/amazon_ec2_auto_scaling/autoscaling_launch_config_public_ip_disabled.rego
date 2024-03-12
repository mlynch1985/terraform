# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    AUTOSCALING_LAUNCH_CONFIG_PUBLIC_IP_DISABLED
#
# Description:
#    Checks if Amazon EC2 Auto Scaling groups have public IP addresses enabled through Launch Configurations.
#    This rule is NON_COMPLIANT if the Launch Configuration for an Auto Scaling group has AssociatePublicIpAddress set to 'true'.
#
# Resource Types:
#    aws_launch_configuration
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_ec2_auto_scaling.autoscaling_launch_config_public_ip_disabled

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_launch_configuration"

level := "HIGH"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

title := "AUTOSCALING_LAUNCH_CONFIG_PUBLIC_IP_DISABLED"

violations[response] {
	id := "AUTOSCALING-1"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	object.get(terraform.resources[j].values, "associate_public_ip_address", true)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource should be configured associate_public_ip_address to false. Please set associate_public_ip_address as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration.html#associate_public_ip_address",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.2.1, 1.3, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
