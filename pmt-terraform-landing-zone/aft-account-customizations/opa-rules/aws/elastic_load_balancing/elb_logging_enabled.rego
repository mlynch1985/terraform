# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    ELB_LOGGING_ENABLED
#
# Description:
#    Checks whether AWS Database Migration Service replication instances are public.
#    The rule is NON_COMPLIANT if PubliclyAccessible field is True.
#
# Resource Types:
#    aws_elb
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.elastic_load_balancing.elb_logging_enabled

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_elb"

title := "ELB_LOGGING_ENABLED"

id := "ELB-1"

cust_id := "Bofa-AxiaMed"

owner := "UNKNOWN"

level := "HIGH"

violations[response] {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	count(object.get(terraform.resources[j].values, "access_logs", [])) == 0

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) does not have access logs configured. Please define a access_logs block https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb#access_logs",
				[terraform.resources[j].address],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 10.1, 10.3.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
