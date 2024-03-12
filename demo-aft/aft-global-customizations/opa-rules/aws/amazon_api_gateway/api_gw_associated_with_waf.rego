# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   API_GW_ASSOCIATED_WITH_WAF
#
# Description:
#     Checks if an Amazon API Gateway API stage is using an AWS WAF web access control list (web ACL).
#	    The rule is NON_COMPLIANT if an AWS WAF Web ACL is not used or if a used AWS Web ACL does not
#	    match what is listed in the rule parameter.
#
# Resource Types:
#    aws_api_gateway_stage, aws_wafv2_web_acl_association
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_api_gateway.api_gw_associated_with_waf

import data.terraform.module as terraform
import data.terraform.module.configurations as configurations
import data.utils as utils
import future.keywords.in

resource_type := "aws_api_gateway_stage"

title := "API_GW_ASSOCIATED_WITH_WAF"

id := "AMAZON_API_GATEWAY-2"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

#check to see that the web acl arn in the terraform plan exists in the config.json list of web acl arns
has_api_stage_waf_association_arn {
	confs := configurations[j]
	utils.array_contains(data.variables.web_acl_arns, confs.expressions.web_acl_arn.constant_value)
}

#check to see that both aws_api_gateway_stage and aws_wafv2_web_acl_association exists in the resource section.
has_api_stage_waf_association {
	types := [x | x := object.get(terraform.resources[j], "type", [])]
	all([utils.array_contains(types, "aws_api_gateway_stage"), utils.array_contains(types, "aws_wafv2_web_acl_association")])
}

#function analyzes the association when aws_wafv2_web_acl is written through terraform
check_waf {
	confs := configurations[t]
	res := terraform.resources[x]
	res.type == "aws_api_gateway_stage"

	#check to see that a web acl was configured through a terraform resource
	utils.has_key(confs.expressions.web_acl_arn, "references")
	has_api_stage_waf_association
	not utils.array_contains(confs.expressions.resource_arn.references, res.address)
}

#function analyzes when a web acl arn is passed to the aws_wafv2_web_acl_association
check_waf {
	#check to see that there are values in the config.json file
	data.variables.web_acl_arns != []
	res := terraform.resources[x]
	res.type == "aws_api_gateway_stage"
	confs := configurations[k]

	#check to see that a web acl arn has been passed
	utils.has_key(confs.expressions.web_acl_arn, "constant_value")
	has_api_stage_waf_association
	not has_api_stage_waf_association_arn
}

#if there are no aws_wafv2_web_acl_association then trigger a finding, else analyze the aws_api_gateway_stage and aws_wafv2_web_acl_association
check {
	types := [x | x := object.get(terraform.resources[j], "type", [])]
	not utils.array_contains(types, "aws_wafv2_web_acl_association")
} else {
	#analyze two scenarios. A aws_wafv2_web_acl written through terraform or a providing a pre created web acl arn directly to the aws_wafv2_web_acl_association
	check_waf
}

violations[response] {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	#call baseline check function
	check

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"Description": sprintf(
				"Resource (%s) aws_api_gateway_stage does not have a aws_wafv2_web_acl_association, the aws_wafv2_web_acl_association is configured incorrectly, or doesn't match web acls %s specified by your organization. Please associate your aws_api_gateway_stage with a wafv2 web acl as shown in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association",
				[terraform.resources[j].address, data.variables.web_acl_arns],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 6.6"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
