# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   ALB_WAF_ENABLED

#
# Description:
#    Checks if AWS WAF is enabled on Application Load Balancers (ALBs).
#    The rule is NON_COMPLIANT if the ALB does not have a WAF association.

#
# Resource Types:
#    aws_lb, aws_wafv2_web_acl_association
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.elastic_load_balancing.alb_waf_enabled

import data.terraform.module as terraform
import data.utils as utils
import future.keywords.in

resource_type := "aws_lb"

title := "ALB_WAF_ENABLED"

id := "ELB-3"

cust_id := "Bofa-AxiaMed"

owner := "UNKNOWN"

level := "HIGH"

#function analyzes the association when aws_wafv2_web_acl is written through terraform for wafv2
check_wafv2 {
	confs := terraform.configurations[t]
	res := terraform.resources[x]
	res.type == "aws_lb"

	#check to see that a web acl was configured through a terraform resource
	utils.has_key(confs.expressions.web_acl_arn, "references")
	not utils.array_contains(confs.expressions.resource_arn.references, res.address)
}

#function analyzes when a web acl arn is passed to the aws_wafv2_web_acl_association for wafv2
check_wafv2 {
	#check to see that there are values in the config.json file
	data.variables.web_acl_arns != []
	res := terraform.resources[x]
	confs := terraform.configurations[k]
	res.type == "aws_lb"

	#check to see that a web acl arn has been passed
	utils.has_key(confs.expressions.web_acl_arn, "constant_value")
	not utils.array_contains(data.variables.web_acl_arns, confs.expressions.web_acl_arn.constant_value)
}

#function analyzes the association when aws_wafregional_web_acl is written through terraform for waf classic
check_waf_classic {
	confs := terraform.configurations[t]
	res := terraform.resources[x]
	res.type == "aws_lb"

	#check to see that a web acl was configured through a terraform resource
	utils.has_key(confs.expressions.web_acl_id, "references")
	not utils.array_contains(confs.expressions.resource_arn.references, res.address)
}

#function analyzes when a web acl arn is passed to the aws_wafregional_web_acl for waf classic
check_waf_classic {
	#check to see that there are values in the config.json file
	data.variables.web_acl_arns != []
	res := terraform.resources[x]
	confs := terraform.configurations[k]
	res.type == "aws_lb"

	#check to see that a web acl arn has been passed
	utils.has_key(confs.expressions.web_acl_id, "constant_value")
	not utils.array_contains(data.variables.web_acl_ids, confs.expressions.web_acl_id.constant_value)
}

#determine if we are analyzing a wafv2 or waf classic association
wafv2_vs_wafclassic(types) {
	utils.array_contains(types, "aws_wafv2_web_acl_association")
	check_wafv2
}

#determine if we are analyzing a wafv2 or waf classic association
wafv2_vs_wafclassic(types) {
	utils.array_contains(types, "aws_wafregional_web_acl_association")
	check_waf_classic
}

#check to see that aws_wafv2_web_acl_association resource defined
wafv2_or_wafclassic(types) {
	utils.array_contains(types, "aws_wafv2_web_acl_association")
}

#check to see that aws_wafregional_web_acl_association resource defined
wafv2_or_wafclassic(types) {
	utils.array_contains(types, "aws_wafregional_web_acl_association")
}

#if there are no aws_wafv2_web_acl_association or aws_wafregional_web_acl_association then trigger a finding, else analyze the aws_lb and aws_wafv2_web_acl_association
check {
	types := [x | x := object.get(terraform.resources[t], "type", [])]
	not wafv2_or_wafclassic(types)
} else {
	types := [x | x := object.get(terraform.resources[a], "type", [])]
	wafv2_vs_wafclassic(types)
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
			"severity": level,
			"Description": sprintf(
				"aws_lb does not have a aws_wafv2_web_acl_association or aws_wafregional_web_acl_association, the aws_wafv2_web_acl_association or aws_wafregional_web_acl_association is configured incorrectly, or doesn't match web acls arns %s or web acl ids %s specified by your organization. Please associate your aws_lb with a wafv2 web acl of waf classic acl as shown in these documentations https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association, https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafregional_web_acl",
				[data.variables.web_acl_arns],
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
