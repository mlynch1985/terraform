# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    S3_BUCKET_ACL_PROHIBITED
#
# Description:
# Checks if Amazon Simple Storage Service (Amazon S3) Buckets allow user permissions through access control lists (ACLs).
# The rule is NON_COMPLIANT if ACLs are configured for user access in Amazon S3 Buckets.
#
# Resource Types:
#    aws_s3_bucket_acl
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_s3.s3_bucket_acl_prohibited

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

resource_type := "aws_s3_bucket_acl"

title := "S3_BUCKET_ACL_PROHIBITED"

level := "HIGH"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

violations contains response if {
	id := "S3-5"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	access_control_policy := object.get(terraform.resources[j].values, "access_control_policy", [])
	count(access_control_policy) > 0

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
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1.1, 7.2.3"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
