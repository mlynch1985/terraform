# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    S3_BUCKET_LEVEL_PUBLIC_ACCESS_PROHIBITED
#
# Description:
# Checks if S3 buckets are publicly accessible.
# The rule is NON_COMPLIANT if an S3 bucket is not listed in the excludedPublicBuckets parameter
# and bucket level settings are public.
#
# Resource Types:
#    aws_s3_bucket, aws_s3_bucket_public_access_block
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_s3.s3_bucket_level_public_access_prohibited

import data.ignore_rules.id as opa_ignore_id
import data.terraform.module as terraform
import data.utils as utils
import future.keywords

resource_type := ["aws_s3_bucket", "aws_s3_bucket_public_access_block"]

title := "S3_BUCKET_LEVEL_PUBLIC_ACCESS_PROHIBITED"

level := "HIGH"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

is_s3_publicly_accessible(s3_tf_resource) if {
	s3_tf_resource.type == "aws_s3_bucket"
	acl := object.get(s3_tf_resource.values, "acl", "private")
	utils.array_contains(["public-read", "public-read-write"], acl)
}

is_s3_publicly_accessible(s3_tf_resource) if {
	s3_tf_resource.type == "aws_s3_bucket_public_access_block"
	values := [object.get(s3_tf_resource.values, "block_public_acls", false), object.get(s3_tf_resource.values, "block_public_policy", false), object.get(s3_tf_resource.values, "ignore_public_acls", false), object.get(s3_tf_resource.values, "restrict_public_buckets", false)]
	utils.array_contains(values, false)
}

violations contains response if {
	id := "S3-6"
	not utils.array_contains(opa_ignore_id, id)

	utils.array_contains(resource_type, terraform.resources[j].type)

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	is_s3_publicly_accessible(terraform.resources[j])

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "S3 ACLs should not be used to grant users access to S3 buckets, use bucket policies instead.",

		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
