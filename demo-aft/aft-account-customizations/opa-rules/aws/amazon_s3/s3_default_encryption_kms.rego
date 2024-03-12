# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    S3_DEFAULT_ENCRYPTION_KMS
#
# Description:
# Checks whether the Amazon S3 buckets are encrypted with AWS Key Management Service(AWS KMS).
# The rule is NON_COMPLIANT if the Amazon S3 bucket is not encrypted with AWS KMS key.
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

package aws.amazon_s3.s3_default_encryption_kms

import data.frameworks as frameworks
import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_s3_bucket"

title := "S3_DEFAULT_ENCRYPTION_KMS"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	id := "S3-3"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not utils.has_key(terraform.resources[j].values, "server_side_encryption_configuration")

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource does not have KMS encryption configured. Please define a server_side_encryption_configuration block, set sse_algorithm to aws:kms, and provide a kms_master_key_id as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 3.4, 10.5, 10.5.2, 3.5.3, 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

violations[response] {
	id := "S3-3"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	utils.has_key(terraform.resources[j].values, "server_side_encryption_configuration")
	sse_configuration = terraform.resources[j].values.server_side_encryption_configuration
	sse_configuration[_].rule[_].apply_server_side_encryption_by_default[_].sse_algorithm != "aws:kms"

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) has the incorrect sse_algorithm configured. Please define a server_side_encryption_configuration block, set sse_algorithm to aws:kms, and provide a kms_master_key_id as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket",
			[id, level, terraform.resources[j].address],
		),
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 3.4, 10.5, 10.5.2, 3.5.3, 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
