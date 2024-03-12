## © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    LAMBDA_FUNCTION_PUBLIC_ACCESS_PROHIBITED
#
# Description:
#   Ensures the lambda resource based policy does not have a principal *.
#
# Resource Types:
#    aws_lambda_permission
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.lambda.lambda_function_public_access_prohibited

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

resource_type := "aws_lambda_permission"

id := "LAMBDA-2"

title := "LAMBDA_FUNCTION_PUBLIC_ACCESS_PROHIBITED"

level := "HIGH"

has_public_access(principal) if {
	principal == "*"
}

has_public_access(principal) if {
	lower(principal) == "aws:*"
}

has_public_access(principal) if {
	lower(principal) == "arn:aws:*"
}

is_public(account) if {
	not account
}

is_public(account) if {
	any([is_null(account), account == "*", account == ""])
}

violations contains response if {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	# terraform.resources[j].values.principal == "*"
	principal := terraform.resources[j].values.principal
	has_public_access(principal)

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) has a * in the Princial segment of its policy. Thus, when attached to a lambda function it creates a publicy accessible lambda. Please remove the *",
			[id, level, terraform.resources[j].address],
		),
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

violations contains response if {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	glob.match("*.amazonaws.com", [], lower(terraform.resources[j].values.principal))
	source_account := object.get(terraform.resources[j].values, "source_account", null)
	source_arn := object.get(terraform.resources[j].values, "source_arn", null)

	is_null(source_account)
	is_null(source_arn)

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) has a Service in the Princial segment of its policy. Thus, when attached to a lambda function it creates a publicy accessible lambda. Please use either of the arguments source_account or source_arn",
			[id, level, terraform.resources[j].address],
		),
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

violations contains response if {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	glob.match("*.amazonaws.com", [], lower(terraform.resources[j].values.principal))
	source_account := object.get(terraform.resources[j].values, "source_account", null)

	not is_null(source_account)
	is_public(source_account)

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) has a Service in the Princial segment of its policy and the source_account is not restrictive. Thus, when attached to a lambda function it creates a publicy accessible lambda. Please limit to an account using the argument: source_account",
			[id, level, terraform.resources[j].address],
		),
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

violations contains response if {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	glob.match("*.amazonaws.com", [], lower(terraform.resources[j].values.principal))
	source_arn := object.get(terraform.resources[j].values, "source_arn", null)

	not is_null(source_arn)
	count(split(source_arn, ":")) < 4

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) has a Service in the Princial segment of its policy and the source_arn is not restrictive. Thus, when attached to a lambda function it creates a publicy accessible lambda. Please limit to an account using the argument: source_arn",
			[id, level, terraform.resources[j].address],
		),
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

violations contains response if {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	glob.match("*.amazonaws.com", [], lower(terraform.resources[j].values.principal))
	source_arn := object.get(terraform.resources[j].values, "source_arn", null)

	not is_null(source_arn)
	count(split(source_arn, ":")) >= 4
	source_arn_account := split(source_arn, ":")[4]
	is_public(source_arn_account)

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) has a Service in the Princial segment of its policy and the source_arn is not restrictive. Thus, when attached to a lambda function it creates a publicy accessible lambda. Please limit to an account using the argument: source_arn",
			[id, level, terraform.resources[j].address],
		),
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
