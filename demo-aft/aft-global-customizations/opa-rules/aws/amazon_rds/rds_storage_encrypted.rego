# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    RDS_STORAGE_ENCRYPTED
#
# Description:
#    Checks if storage encryption is enabled for your RDS DB instances.
#    The rule is NON_COMPLIANT if storage encryption is not enabled.
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
package aws.amazon_rds.rds_storage_encrypted

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_db_instance"

title := "RDS_STORAGE_ENCRYPTED"

level := "CRITICAL"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	id := "RDS-7"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not object.get(terraform.resources[j].values, "storage_encrypted", false)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource %s does not have storage_encrypted configured. Please set storage_encrypted to true as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 3.4, 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
