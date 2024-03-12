# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    S3_BUCKET_REPLICATION_ENABLED
#
# Description:
#    Checks if your Amazon S3 buckets have replication rules enabled.
#    The rule is NON_COMPLIANT if an S3 bucket does not have a replication rule or has a replication rule that is not enabled.
#
# Resource Types:
#    aws_s3_bucket
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_s3.s3_bucket_replication_enabled

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

resource_type := "aws_s3_bucket"

title := "S3_BUCKET_REPLICATION_ENABLED"

level := "HIGH"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

violations contains response if {
	id := "S3-2"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)
	# Check if replication_configuration is not emtpy for aws_s3_bucket
	object.get(terraform.resources[j].values, "replication_configuration", false)
	replcation_flag := {c |
	 	c := terraform.resources[j].values["replication_configuration"][_]["rules"][_]["status"]

	}
	# Check if s3_replcation is enabled or not
	not replcation_flag == {"Enabled"}
	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource does not have replication configuration rules. Please provide replication configuration as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 10.5.3"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
