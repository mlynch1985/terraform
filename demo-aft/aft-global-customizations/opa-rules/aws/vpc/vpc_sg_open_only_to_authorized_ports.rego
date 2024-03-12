# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   VPC_SG_OPEN_ONLY_TO_AUTHORIZED_PORTS
#
# Description:
#    Checks if security groups allowing unrestricted incoming traffic ('0.0.0.0/0' or '::/0') only allow inbound TCP or UDP connections on authorized ports.
#    The rule is NON_COMPLIANT if such security groups do not have ports specified in the rule parameters
#
# Resource Types:
#    aws_security_group
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.vpc.vpc_sg_open_only_to_authorized_ports

import data.terraform.module as terraform
import data.utils as utils

# This is used for output and resource filtering (from mock data)
resource_type := "aws_security_group"

title := "VPC_SG_OPEN_ONLY_TO_AUTHORIZED_PORTS"

id := "VPC-2"

level := "CRITICAL"

cust_id := "TBD"

owner := "TBD"

#comepare the port range configured to the authorized_ports list
check_range(range, to_port, from_port) {
	ports := split(range, "-")
	all([to_number(ports[0]) == from_port, to_number(ports[1]) == to_port])
}

#for every authorized_ports, check that the port range configured exists in the approaved list
check_ports(to_port, from_port, authorized_ports) {
	port_range_valid := [s | s := check_range(authorized_ports[k], to_port, from_port)]
	not utils.array_contains(port_range_valid, true)
}

tcp_vs_udp(ingress_block) {
	ingress_block.protocol == "tcp"
	check_ports(ingress_block.to_port, ingress_block.from_port, data.variables.authorized_tcp_ports)
}

tcp_vs_udp(ingress_block) {
	ingress_block.protocol == "udp"
	check_ports(ingress_block.to_port, ingress_block.from_port, data.variables.authorized_udp_ports)
}

#function checkes if the cidr range for the ingress block is 0.0.0.0/0 and if so if the ports are approved
check_ingress_block(ingress_block) {
	utils.array_contains(ingress_block.cidr_blocks, "0.0.0.0/0")
	tcp_vs_udp(ingress_block)
}

violations[response] {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	utils.has_key(terraform.resources[j].values, "ingress")
	check_ingress_block(terraform.resources[j].values.ingress[x])

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) security group should not have ingress allowed from 0.0.0.0/0 to a port range that is not in the tcp authorized list (%s) or udp authorized list (%s). https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#ingress",
				[terraform.resources[j].address, data.variables.authorized_tcp_ports, data.variables.authorized_udp_ports],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
