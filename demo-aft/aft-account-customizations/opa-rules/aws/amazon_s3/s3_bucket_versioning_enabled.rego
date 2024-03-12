# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    S3_BUCKET_VERSIONING_ENABLED
#
# Description:
# Checks if versioning is enabled for your S3 buckets. Optionally, the rule checks if MFA delete is enabled for your S3 buckets.
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

package aws.amazon_s3.s3_bucket_versioning_enabled

import data.frameworks as frameworks
import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_s3_bucket"

title := "S3_BUCKET_VERSIONING_ENABLED"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	id := "S3-9"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not utils.has_key(terraform.resources[j].values, "versioning")

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource is specifically dealing with S3 buckets, which must have versioning enabled. Please enbale S3 object-versioning as detailed here https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 10.5.5"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

violations[response] {
	level := "HIGH"
	id := "S3-9"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	encryption = terraform.resources[j].values.versioning[_].enabled
	encryption == false

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource (%s) is specifically dealing with S3 buckets, which must have versioning enabled. Please enbale S3 object-versioning as detailed here https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 10.5.5"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
