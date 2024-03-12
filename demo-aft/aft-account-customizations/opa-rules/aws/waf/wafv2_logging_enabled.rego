# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   WAFV2_LOGGING_ENABLED
#
# Description:
#    Checks if logging is enabled on AWS WAFv2 regional and global web access control lists (web ACLs).
#    The rule is NON_COMPLIANT if the logging is enabled but the logging destination does not match the value of the parameter.
#    KinesisFirehoseDeliveryStreamArns can be configured in the config.json file
#
# Resource Types:
#    aws_wafv2_web_acl
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.waf.wafv2_logging_enabled

import data.terraform.module as terraform
import data.utils as utils
import future.keywords.in

# This is used for output and resource filtering (from mock data)
resource_type := "aws_wafv2_web_acl"

level := "CRITICAL"

title := "WAFV2_LOGGING_ENABLED"

cust_id := "TBD"

owner := "TBD"

has_wafacl_and_logging_config {
	# must contain both aws_wafv2_web_acl_logging_configuration and aws_wafv2_web_acl resource types to qualify
	types := [x | x := object.get(terraform.resources[j], "type", [])]
	all([utils.array_contains(types, "aws_wafv2_web_acl"), utils.array_contains(types, "aws_wafv2_web_acl_logging_configuration")])
}

ref_wafacl {
	# aws_wafv2_web_acl_logging_configuration configuration must reference aws_wafv2_web_acl resource
	has_wafacl_and_logging_config
	confs := terraform.configurations[j]
	res := terraform.resources[x]
	utils.array_contains(confs.expressions.resource_arn.references, res.address)
	#check that logging was configured
	utils.array_contains(confs.expressions.log_destination_configs.references, data.variables.kinesis_firehose_delivery_stream_arns)
}

violations[response] {
	id := "WAF-1"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	terraform.resources[j].values.scope == "REGIONAL"
	not ref_wafacl

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource WAF must have logging configured. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 10.1, 10.3.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
