# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    CODEBUILD_PROJECT_LOGGING_ENABLED
#
# Description:
#    Checks if an AWS CodeBuild project environment has at least one log option enabled.
#    The rule is NON_COMPLIANT if the status of all present log configurations is set to 'DISABLED'.
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

package aws.codebuild.codebuild_project_logging_enabled

import data.terraform.module as terraform
import data.utils as utils

import future.keywords

resource_type := "aws_codebuild_project"

title := "CODEBUILD_PROJECT_LOGGING_ENABLED"

id := "CODEBUILD-2"

level := "HIGH"

cust_id := "Bofa-AxiaMed"

owner := "UNKNOWN"

is_logs_disabled(lcfg) if {
	lcfg == []
} else if {
	vars := {v |
		v := object.get(lcfg[_][_][_], "status", "ENABLED")
	}
	not "ENABLED" in vars
}

violations contains response if {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	lcfg = object.get(terraform.resources[j].values, "logs_config", [])
	is_logs_disabled(lcfg)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) should be configured logs_config to ENABLED. Please set logs_config as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project#logs_config",
				[terraform.resources[j].address],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 10.1, 10.2.1, 10.2.2, 10.2.3, 10.2.4, 10.2.5, 10.3.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
