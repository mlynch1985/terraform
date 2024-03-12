# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED
#
# Description:
#    Checks if your Amazon S3 bucket either has the Amazon S3 default encryption enabled
#    or that the Amazon S3 bucket policy explicitly denies put-object requests without server side encryption that uses AES-256 or AWS Key Management Service.
#    The rule is NON_COMPLIANT if your Amazon S3 bucket is not encrypted by default.
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

package aws.amazon_s3.s3_bucket_server_side_encryption_enabled

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

resource_type := "aws_s3_bucket"

title := "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

is_sse_res_not_exists(rep, bucket_addr) if {
	count(rep) == 0
} else if {
	sr_list := {c |
		c := rep[q]
		is_present(rep[q], bucket_addr)
	}
	count(sr_list) == 0
}

is_present(res, bucket_addr) if {
	bucket_addr in res.expressions.bucket.references
	res.expressions.rule[_].apply_server_side_encryption_by_default[_].sse_algorithm.constant_value in ["AES256", "aws:kms"]
}

is_sse_prop_exists(res) if {
	object.get(res, "server_side_encryption_configuration", []) != []
	res.server_side_encryption_configuration[_].rule[_].apply_server_side_encryption_by_default[_].sse_algorithm in ["AES256", "aws:kms"]
} else = false

violations contains response if {
	id := "S3-7"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	bkt_addr := terraform.resources[j].address
	not is_sse_prop_exists(terraform.resources[j].values)
	sse_res := {b |
		b := terraform.configurations[x]
		terraform.configurations[x].type == "aws_s3_bucket_server_side_encryption_configuration"
	}
	is_sse_res_not_exists(sse_res, bkt_addr)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource does not have server_side_encryption encryption configured. Please define a server_side_encryption_configuration block, set sse_algorithm to aws:kms, and provide a kms_master_key_id as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 3.4, 10.5, 10.5.2, 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
