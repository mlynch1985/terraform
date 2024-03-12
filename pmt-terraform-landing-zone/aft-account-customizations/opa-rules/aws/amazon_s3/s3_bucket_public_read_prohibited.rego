# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    S3_BUCKET_PUBLIC_READ_PROHIBITED
#
# Description:
#    The rule is compliant when both of the following are true:
#        The Block Public Access setting restricts public policies or the bucket policy does not allow public read access.
#        The Block Public Access setting restricts public ACLs or the bucket ACL does not allow public read access.
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

package aws.amazon_s3.s3_bucket_public_read_prohibited

import data.terraform.module as terraform
import data.utils as utils
import future.keywords

resource_type := "aws_s3_bucket"

title := "S3_BUCKET_PUBLIC_READ_PROHIBITED"

level := "HIGH"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

is_acl_public_read(res, acl_res) if {
	bucket_addr = res.address
	sr_list := {c |
		c := acl_res[q]
		is_present(acl_res[q], bucket_addr)
	}
	count(sr_list) != 0
}

is_present(res, bucket_addr) if {
	bucket_addr in res.expressions.bucket.references
	res.expressions.acl.constant_value == "public-read"
}

violations contains response if {
	id := "S3-11"
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	object.get(terraform.resources[j].values, "acl", "private") == "public-read"

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource is an S3 bucket that does not have acl set to public-read. Please set acl as described in the documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket",

		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 2.2, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

violations contains response if {
	id := "S3-11"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	rep_res := {b |
		b := terraform.configurations[x]
		terraform.configurations[x].type == "aws_s3_bucket_acl"
	}
	is_acl_public_read(terraform.resources[j], rep_res)

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) is an S3 bucket that does not have aws_s3_bucket_acl set to public-read. Please set acl as described in the documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket",
			[id, level, terraform.resources[j].address],
		),
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 2.2, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
