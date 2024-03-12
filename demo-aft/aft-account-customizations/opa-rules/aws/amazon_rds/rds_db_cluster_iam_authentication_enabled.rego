# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    RDS_IAM_AUTHENTICATION_ENABLED
#
# Description:
#    Checks if an Amazon Relational Database Service (Amazon RDS) cluster has AWS Identity and Access Management (IAM) authentication enabled.
#    The rule is NON_COMPLIANT if an Amazon RDS Cluster does not have IAM authentication enabled.
# Resource Types:
#    aws_db_instance
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.amazon_rds.rds_iam_authetication_enabled

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_rds_cluster"

title := "RDS_IAM_AUTHENTICATION_ENABLED"

level := "CRITICAL"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	id := "RDS-10"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)
	# Check if iam_database_authentication_enabled is set to true for RDS cluster
	iam_db_authentication := object.get(terraform.resources[j].values, "iam_database_authentication_enabled", null)
	not iam_db_authentication == true

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource does not have IAM authentication enabled. Please set iam_database_authentication_enabled to true as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/2.33.0/docs/resources/rds_cluster",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 3.4, 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
