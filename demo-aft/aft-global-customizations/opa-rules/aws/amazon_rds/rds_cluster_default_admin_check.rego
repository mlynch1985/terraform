# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   RDS_CLUSTER_DEFAULT_ADMIN_CHECK
#
# Description:
#    "Checks if an Amazon Relational Database Service (Amazon RDS) database cluster has changed the admin username from its default value. The rule is NON_COMPLIANT if the admin username is set to the default value."
#
# Resource Types:
#    aws_rds_dbcluster
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.rds.rds_cluster_default_admin_check

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

# This is used for output and resource filtering (from mock data)
resource_type := "aws_rds_cluster"

title := "RDS_CLUSTER_DEFAULT_ADMIN_CHECK"

level := "CRITICAL"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

violations contains response if {
	id := "RDS-5"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	default_usernames := ["admin", "postgres"]
	terraform.resources[j].values.master_username in default_usernames

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource should be configured with a new master_username that is not in any of %s. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster#master_username ",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
