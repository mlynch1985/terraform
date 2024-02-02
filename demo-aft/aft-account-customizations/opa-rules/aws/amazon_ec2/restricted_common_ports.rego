# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    RESTRICTED_INCOMING_TRAFFIC
#
# Description:
#    Checks if the security groups in use do not allow unrestricted incoming TCP traffic to the specified ports.
#    The rule is COMPLIANT when the IP addresses for inbound TCP connections are restricted to the specified ports. This rule applies only to IPv4.
#
# Resource Types:
#    aws_security_group, aws_security_group_rule
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.amazon_ec2.restricted_common_ports

import data.terraform.module as terraform
import data.utils as utils

import future.keywords

title := "RESTRICTED_INCOMING_TRAFFIC"

level := "CRITICAL"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

common_ports := [20, 21, 3389, 3306, 4333]

protos := ["tcp", "udp"]

violations contains response if {
	id := "EC2-7"

	terraform.resources[j].type == "aws_security_group"

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	terraform.resources[j].values.ingress[_].from_port in common_ports
	terraform.resources[j].values.ingress[_].to_port in common_ports
	lower(terraform.resources[j].values.ingress[_].protocol) in protos

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource has unrestricted incoming TCP/UDP traffic to the specified ports [20, 21, 3389, 3306, 4333]. change the FromPort and ToPort as detailed in here https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#ingress",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 2.2, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

violations contains response if {
	id := "EC2-7"

	terraform.resources[j].type == "aws_security_group_rule"

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	terraform.resources[j].values.type == "ingress"
	terraform.resources[j].values.from_port in common_ports
	terraform.resources[j].values.to_port in common_ports
	lower(terraform.resources[j].values.protocol) in protos

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource has unrestricted incoming TCP/UDP traffic to the specified ports [20, 21, 3389, 3306, 4333]. change the FromPort and ToPort as detailed in here https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 2.2, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
