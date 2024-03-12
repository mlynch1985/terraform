# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    RDS_LOGGING_ENABLED
#
# Description:
#    Checks that respective logs of Amazon Relational Database Service (Amazon RDS) are enabled.
#    The rule is NON_COMPLIANT if any log types are not enabled.
#
# Resource Types:
#    aws_db_instance
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.amazon_rds.rds_logging_enabled

import data.terraform.module as terraform
import data.utils as utils

import future.keywords

resource_type := "aws_db_instance"

title := "RDS_LOGGING_ENABLED"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

violations contains response if {
	id := "RDS-3"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	object.get(terraform.resources[j].values, "enabled_cloudwatch_logs_exports", null) in {null, []}

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource logging should be enabled. Please set enabled_cloudwatch_logs_exports to export audit logs for DB instances: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#enabled_cloudwatch_logs_exports",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 10.1, 10.2.1, 10.2.2, 10.2.3, 10.2.4, 10.2.5, 10.2.6, 10.2.7, 10.3.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
