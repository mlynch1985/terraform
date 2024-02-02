# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    ECS_TASK_DEFINITION_NONROOT_USER
#
# Description:
# Checks if ECSTaskDefinitions specify a user for Amazon Elastic Container Service (Amazon ECS) EC2 launch type containers to run on.
# The rule is NON_COMPLIANT if the ‘user’ parameter is not present or set to ‘root’.
#
# Resource Types:
#    aws_ecs_task_definition
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_ecs.ecs_task_definition_nonroot_user

import data.frameworks as frameworks
import data.ignore_rules as ignore_rules
import data.terraform.module as terraform
import data.utils as utils
import future.keywords

resource_type := "aws_ecs_task_definition"

level := "CRITICAL"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

title := "ECS_TASK_DEFINITION_NONROOT_USER"

violations contains response if {
	id := "ECS-5"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	container_definitions := object.get(terraform.resources[j].values, "container_definitions", [])
	user := object.get(container_definitions[_], "user", "")
	user in {"", "root"}

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource ECS Task definition should specify a user distinct from root. https://docs.aws.amazon.com/config/latest/developerguide/ecs-containers-nonprivileged.html",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
