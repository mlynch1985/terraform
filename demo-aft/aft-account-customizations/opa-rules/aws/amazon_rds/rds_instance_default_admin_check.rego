# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   RDS_INSTANCE_DEFAULT_ADMIN_CHECK
#
# Description:
#    "Checks if an Amazon Relational Database Service (Amazon RDS) database has changed the admin username from its default value. This rule will only run on RDS database instances. The rule is NON_COMPLIANT if the admin username is set to the default value."
#
# Resource Types:
#    aws_rds_dbinstance
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.rds.rds_instance_default_admin_check

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

# This is used for output and resource filtering (from mock data)
resource_type := "aws_db_instance"

title := "RDS_INSTANCE_DEFAULT_ADMIN_CHECK"

level := "CRITICAL"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

violations contains response if {
	id := "RDS-4"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	default_usernames := ["admin", "postgres"]
	terraform.resources[j].values.username in default_usernames

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource should be configured with a new username that is not in any of %s'. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#username",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
