# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    ELB_DELETE_PROTECTION_ENABLED
#
# Description:
#    Checks if an Elastic Load Balancer has deletion protection enabled.
#    The rule is NON_COMPLIANT if enable_deletion_protection is false.
#
# Resource Types:
#    aws_lb
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

# Check if automatic backups are enabled
package aws.elastic_load_balancing.elb_delete_protection_enabled

import data.ignore_rules as opa_ignore_id
import data.terraform.module as terraform
import data.utils as utils

title := "ELB_DELETE_PROTECTION_ENABLED"

resource_type := "aws_lb"

id := "ELB-4"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	terraform.resources[j].type == resource_type
	not object.get(terraform.resources[j].values, "enable_deletion_protection", false)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) should have Delete protection enabled. Enable Delete proetction by changing the value of enable_deletion_protection parameter to true. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb",
				[terraform.resources[j].address],
			),
		},
		"compliance": {"requirements": ["NIST 800-53.r5"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
