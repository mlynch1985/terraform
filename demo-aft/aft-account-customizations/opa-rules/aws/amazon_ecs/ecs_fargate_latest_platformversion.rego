# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    ECS_FARGATE_LATEST_PLATFORM_VERSION
#
# Description:
# Checks if Amazon Elastic Container Service (ECS) Fargate Services is running on the latest Fargate platform version.
# The rule is NON_COMPLIANT if ECS Service platformVersion not set to LATEST.
#
# Resource Types:
#    aws_ecs_service
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_ecs.ecs_fargate_latest_platformversion

import data.frameworks as frameworks
import data.ignore_rules as ignore_rules
import data.terraform.module as terraform
import data.utils as utils
import future.keywords

resource_type := "aws_ecs_service"

level := "CRITICAL"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

title := "ECS_FARGATE_LATEST_PLATFORM_VERSION"

violations contains response if {
	id := "ECS-3"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	object.get(terraform.resources[j].values, "launch_type", "EC2") = "FARGATE"
	not object.get(terraform.resources[j].values, "platform_version", "LATEST") in {"LATEST", data.variables.ecs_version}

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource ECS Container should not has priviledge access. https://docs.aws.amazon.com/config/latest/developerguide/ecs-containers-nonprivileged.html",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 6.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
