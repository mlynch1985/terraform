# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    CODEBUILD_PROJECT_ENVIRONMENT_PRIVILEGED_CHECK
#
# Description:
#    Checks if an AWS CodeBuild project environment has privileged mode enabled.
#    The rule is NON_COMPLIANT for a CodeBuild project if ‘environment.privileged_mode’ is set to ‘true’.
#
# Resource Types:
#    aws_codebuild_project
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.codebuild.codebuild_project_environment_privileged_check

import data.terraform.module as terraform
import data.utils as utils

import future.keywords

resource_type := "aws_codebuild_project"

title := "CODEBUILD_PROJECT_ENVIRONMENT_PRIVILEGED_CHECK"

id := "CODEBUILD-1"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

violations contains response if {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	object.get(terraform.resources[j].values.environment[_], "privileged_mode", false)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) should be configured with privileged_mode set to false. Please set privileged_mode as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project#privileged_mode",
				[terraform.resources[j].address],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
