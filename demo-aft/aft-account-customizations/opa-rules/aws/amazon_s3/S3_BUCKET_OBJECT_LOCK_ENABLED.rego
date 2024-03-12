# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    S3_BUCKET_OBJECT_LOCK_ENABLED
#
# Description:
# Checks if Object Lock is enabled for S3 buckets.
# Resource Types:
#    aws_s3_bucket
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_s3.s3_bucket_object_lock_enabled

import data.frameworks as frameworks
import data.ignore_rules as ignore_rules
import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_s3_bucket"

title := "S3_BUCKET_OBJECT_LOCK_ENABLED"
bank_control_id := "TBD"
bank_opa_owner := "TBD"
level := "HIGH"
cust_id := "TBD"
owner := "TBD"

violations[response] {
	id := "S3-15"
	not utils.array_contains(ignore_rules.id, id)
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not object.get(terraform.resources[j].values, "object_lock_enabled", false) # Check if the object_lock_enabled parameter is present and set the value to True

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource is specifically dealing with S3 buckets, which must have object lock enabled. Please enable S3 object-lock as detailed here https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket",

		},
		"compliance": {"requirements": ["NIST 800-53.r5"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
