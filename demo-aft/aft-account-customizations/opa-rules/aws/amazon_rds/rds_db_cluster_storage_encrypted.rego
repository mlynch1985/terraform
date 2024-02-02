# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    RDS_BD_CLUSTER_STORAGE_ENCRYPTED
#
# Description:
#    Check if the RDS DB Clusters have storage encrypted
#
# Resource Types:
#    aws_rds_cluster
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_rds.rds_db_cluster_storage_encrypted

import data.ignore_rules as opa_ignore_id
import data.terraform.module as terraform
import data.utils as utils

title := "RDS_DB_CLUSTER_STORAGE_ENCRYPTED"
resource_type := "aws_rds_cluster"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

violations[response] {
	id := "RDS-9"
	level := "HIGH"

	not utils.array_contains(opa_ignore_id, id)
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not object.get(terraform.resources[j].values, "storage_encrypted", false) # Check if the storage_encrypted is present and set to true or not

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource storage encryption is not enabled. Enable storage_encrypted parameter to true. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster",
		},
		"compliance": {"requirements": ["NIST 800-53.r5"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
