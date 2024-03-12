# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    ECS_NO_ENVIRONMENT_SECRETS
#
# Description:
# Checks if secrets are passed as container environment variables.
# The rule is NON_COMPLIANT if 1 or more environment variable key matches a key listed in the 'secretKeys' parameter (excluding environmental variables from other locations such as Amazon S3).
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

package aws.amazon_ecs.ecs_no_environment_secrets

import data.frameworks as frameworks
import data.terraform.module as terraform
import data.utils as utils
import future.keywords

resource_type := "aws_ecs_task_definition"

level := "CRITICAL"

title := "ECS_NO_ENVIRONMENT_SECRETS"

cust_id := "TBD"

owner := "TBD"

violations contains response if {
	id := "ECS-4"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	container_definitions := object.get(terraform.resources[j].values, "container_definitions", [])

	some k
	env_vars := object.get(container_definitions[k], "environment", [])
	object.get(env_vars[_], "name", false) in data.variables.secret_keys

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource ECS Container should not pass secrets as container environment variables. https://docs.aws.amazon.com/config/latest/developerguide/ecs-containers-nonprivileged.html",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
