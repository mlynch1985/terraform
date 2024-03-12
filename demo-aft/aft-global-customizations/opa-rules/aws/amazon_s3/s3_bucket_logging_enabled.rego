# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    S3_BUCKET_LOGGING_ENABLED
#
# Description:
#    Checks if logging is enabled for your S3 buckets.
#    The rule is NON_COMPLIANT if logging is not enabled.
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

package aws.amazon_s3.s3_bucket_logging_enabled

import data.ignore_rules as ignore_rules
import data.terraform.module as terraform
import data.utils as utils
import future.keywords

resource_type := "aws_s3_bucket"

title := "S3_BUCKET_LOGGING_ENABLED"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

is_src_or_target(rep, bucket_addr) if {
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
} else if {
	bucket_addr in res.expressions.target_bucket.references
}

violations contains response if {
	id := "S3-10"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	rep_res := {b |
		b := terraform.configurations[x]
		terraform.configurations[x].type == "aws_s3_bucket_logging"
	}

	# if log attribut not present
	count(object.get(terraform.resources[j].values, "logging", [])) == 0

	# if aws_se_bucket_logging resource added
	is_src_or_target(rep_res, terraform.resources[j].address)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource is an S3 bucket that does not have logging enabled. Please enable logging as described in the documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#logging",

		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 10.1, 10.2.1, 10.2.3, 10.2.4, 10.3.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
