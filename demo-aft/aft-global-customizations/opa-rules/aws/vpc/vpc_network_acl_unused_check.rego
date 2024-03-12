# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   VPC_NETWORK_ACL_UNUSED_CHECK
#
# Description:
#     "Checks if there are unused network access control lists (network ACLs).
#     The rule is NON_COMPLIANT if a network ACL is not associated with a subnet."
#
# Resource Types:
#    aws_network_acl
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.vpc.vpc_network_acl_unused_check

import data.terraform.module as terraform
import data.utils as utils

# This is used for output and resource filtering (from mock data)
resource_type := "aws_network_acl"

title := "VPC_NETWORK_ACL_UNUSED_CHECK"

level := "HIGH"

id := "VPC-4"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not utils.has_key(terraform.resources[j].values, "subnet_ids")

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) Network ACL must be associated with a subnet. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl#subnet_ids",
				[terraform.resources[j].address],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.4"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
