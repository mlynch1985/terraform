# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   SECRETSMANAGER_ROTATION_ENABLED_CHECK
#
# Description:
#   Checks if AWS Secrets Manager secret has rotation enabled. The rule also checks an optional maximumAllowedRotationFrequency parameter.
#   If the parameter is specified, the rotation frequency of the secret is compared with the maximum allowed frequency.
#   The rule is NON_COMPLIANT if the secret is not scheduled for rotation.
#   The rule is also NON_COMPLIANT if the rotation frequency is higher than the number specified in the maximumAllowedRotationFrequency parameter
#
# Resource Types:
#    aws_secretsmanager_secret
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.secrets_manager.secretsmanager_rotation_enabled_check

import data.terraform.module as terraform
import data.utils as utils
import future.keywords.in

# This is used for output and resource filtering (from mock data)
resource_type := "aws_secretsmanager_secret"

level := "CRITICAL"

cust_id := "TBD"

owner := "TBD"

title := "SECRETSMANAGER_ROTATION_ENABLED_CHECK"

has_secret_and_rotation {
	types := [x | x := object.get(terraform.resources[j], "type", [])]
	all([utils.array_contains(types, "aws_secretsmanager_secret"), utils.array_contains(types, "aws_secretsmanager_secret_rotation")])
}

ref_rotation {
	has_secret_and_rotation
	confs := terraform.configurations[j]
	res := terraform.resources[x]
	utils.array_contains(confs.expressions.secret_id.references, res.address)
	utils.has_key(confs.expressions.rotation_rules[0], "automatically_after_days")
	confs.expressions.rotation_rules[0].automatically_after_days.constant_value < data.variables.secrets_maximum_allowed_rotation_frequency
}

violations[response] {
	id := "SECRETS_MANAGER-2"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not ref_rotation

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource secret does not have rotation enabled or has an incorrect rotation frequency of greater than %s. Refer to this documentation on how to configure rotation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 8.2.4"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
