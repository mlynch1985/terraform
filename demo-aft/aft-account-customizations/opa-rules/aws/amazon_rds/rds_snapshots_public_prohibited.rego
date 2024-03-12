# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    RDS_SNAPSHOTS_PUBLIC_PROHIBITED

#
# Description:
# Manage access to resources in the AWS Cloud by ensuring that Amazon Relational Database Service (Amazon RDS) instances are not public. Amazon RDS database instances can contain sensitive information and principles and access control is required for such accounts.
#
# Resource Types:
#    aws_db_snapshot
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.rds.rds_snapshots_public_prohibited

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

resource_type := "aws_db_snapshot"

level := "CRITICAL"

title := "RDS_SNAPSHOTS_PUBLIC_PROHIBITED"

cust_id := "TBD"

owner := "TBD"

shared_accounts_contains_all(shared_accounts) if {
	shared_accounts == "all"
}

shared_accounts_contains_all(shared_accounts) if {
	"all" in shared_accounts
}

violations contains response if {
	id := "RDS-1"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	# shared_accounts_contains_all

	shared_accounts := object.get(terraform.resources[j].values, "shared_accounts", [])
	shared_accounts_contains_all(shared_accounts)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource has shared_accounts : [all] configured. Please remove all from the shared_accounts set. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_snapshot#shared_accounts",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
