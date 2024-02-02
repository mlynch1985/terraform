# This AWS Content is provided subject to the terms of the AWS Customer Agreement 
# available at http://aws.amazon.com/agreement or other written agreement between 
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both. 

# Rule Identifier:
#    RDS_INSTANCE_PUBLIC_ACCESS_CHECK
#
# Description:
#    Checks whether the Amazon Relational Database Service (RDS) instances are not publicly accessible. 
#    The rule is non-compliant if the publiclyAccessible field is true in the instance configuration item. 
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
package aws.amazon_rds.rds_instance_public_access_check

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_db_instance"

title := "RDS_INSTANCE_PUBLIC_ACCESS_CHECK"

level := "CRITICAL"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

violations[response] {
	id := "RDS-2"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	object.get(terraform.resources[j].values, "publicly_accessible", false)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource should prohibit public access. Please set publicly_accessible to false as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance",
		},
		"compliance": {
			"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"],
			"Related requirements": [
				"PCI DSS v3.2.1/1.2.1",
				"PCI DSS v3.2.1/1.3.1",
				"PCI DSS v3.2.1/1.3.2",
				"PCI DSS v3.2.1/1.3.4",
				"PCI DSS v3.2.1/1.3.6",
				"PCI DSS v3.2.1/7.2.1",
				"NIST.800-53.r5 AC-4",
				"NIST.800-53.r5 AC-4(21)",
				"NIST.800-53.r5 SC-7",
				"NIST.800-53.r5 SC-7(11)",
				"NIST.800-53.r5 SC-7(16)",
				"NIST.800-53.r5 SC-7(21)",
				"NIST.800-53.r5 SC-7(4)",
				"NIST.800-53.r5 SC-7(5)"
			],
			"Category": {
				"Protect": "Secure network configuration"
			}
		},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
