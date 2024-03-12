# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    ECS_CONTAINERS_NONPRIVILEGED
#
# Description:
#  Checks if the privileged parameter in the container definition of ECSTaskDefinitions is set to ‘true’.
#  The rule is NON_COMPLIANT if the privileged parameter is ‘true’.
#
# Resource Types:
#    ecs_task_definition
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_ecs.ecs_containers_nonprivileged

import data.frameworks as frameworks
import data.ignore_rules as ignore_rules
import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_ecs_task_definition"

level := "CRITICAL"

title := "ECS_CONTAINERS_NONPRIVILEGED"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	id := "ECS-1"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	container_definitions := object.get(terraform.resources[j].values, "container_definitions", [])
	object.get(container_definitions[_], "privileged", true)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource Image scanning for ECR repository should be enabled. https://docs.aws.amazon.com/config/latest/developerguide/ecr-private-image-scanning-enabled.html",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1.1, 7.2.1, 7.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
