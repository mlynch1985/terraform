# This AWS Content is provided subject to the terms of the AWS Customer Agreement 
# available at http://aws.amazon.com/agreement or other written agreement between 
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both. 

# Rule Identifier:
#    RDS_AUTOMATIC_MINOR_VERSION_UPGRADE_ENABLED
#
# Description:
#    Checks if Amazon Relational Database Service (RDS) database instances are configured for automatic minor version upgrades. 
#    The rule is NON_COMPLIANT if the value of 'auto_minor_version_upgrade' is false. 
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
package aws.amazon_rds.rds_automatic_minor_version_upgrade_enabled

import data.terraform.module as terraform
import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_db_instance"

title := "RDS_AUTOMATIC_MINOR_VERSION_UPGRADE_ENABLED"

level := "HIGH"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

violations[response] {
	id := "RDS-6"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not object.get(terraform.resources[j].values, "auto_minor_version_upgrade", true)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource RDS Instances must be configured to automatically accept minor version upgrades. Please refer to the documentation here https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#auto_minor_version_upgrade",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 6.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
