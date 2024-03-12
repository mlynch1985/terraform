# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    RDS_BD_INSTANCE_BACKUP_PLAN_ATTACHED
#
# Description:
#    Check if the Amazon RDS Instances have automatic backup turned on and have backup plan attached to each instance
#    This rule is non compliant if backup_retention_period is not set to 35
#    This rule is non compliance if backup_selection dont have the resource of type aws_db_instance
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

# Check if automatic backups are enabled
package aws.amazon_rds.rds_db_instance_backup_plan_attached

import data.ignore_rules as opa_ignore_id
import data.terraform.module as terraform
import data.utils as utils
import future.keywords.in

title := "RDS_DB_INSTANCE_BACKUP_PLAN_ATTACHED"
resource_type := "aws_db_instance"
retention_days := "35" # Check if the retention period is set to 35
cust_id := "Bofa-axiamed"
owner := "UNKNOWN"

# Check Backup plan attached to RDS DB Instance
has_rds_and_backup_selection {
	# must contain both aws_db_instance and aws_backup_selection resource types to qualify
	types := [x | x := object.get(terraform.resources[j], "type", [])]
	all([utils.array_contains(types, "aws_db_instance"), utils.array_contains(types, "aws_backup_selection")])
}

# backup selection must reference the RDS DB instance
ref_aws_db_instance {
	has_rds_and_backup_selection
	confs := terraform.configurations[j]
	res := terraform.resources[x]
	utils.array_contains(confs.expressions.resources.references, res.address)
	res.values.backup_retention_period != retention_days
}

# Check if automatic backup retention is enabled for the RDS Instance
backup_enabled(values){
	not utils.has_key(values, "backup_retention_period")
}else{
	not ref_aws_db_instance
}

violations[response] {
	id := "RDS-8"
	level := "HIGH"

	not utils.array_contains(opa_ignore_id, id)
	terraform.resources[j].type == resource_type
	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)
	backup_enabled(terraform.resources[j].values)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource should have automatic backups enabled and have backup plan must be attached. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance_automated_backups_replication",
		},
		"compliance": {"requirements": ["NIST 800-53.r5"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
