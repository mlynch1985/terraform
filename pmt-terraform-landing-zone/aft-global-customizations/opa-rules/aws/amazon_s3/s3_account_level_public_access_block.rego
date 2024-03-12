# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS
#
# Description:
#   Checks if the required public access block settings are configured from account level.
#   The rule is only NON_COMPLIANT when the fields set below do not match the corresponding fields in the configuration item.
#
# Resource Types:
#    aws_s3_bucket_public_access_block
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_s3.s3_account_level_public_access_block

import data.frameworks as frameworks
import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_s3_bucket_public_access_block"

title := "S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS"

level := "CRITICAL"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

violations[response] {
	id := "S3-1"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	terraform.resources[j].type == resource_type
	object.get(terraform.resources[j].values, "block_public_acls", false) == false

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource block_public_acls should be set to true as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block",
		},
		"severity": level,
		"severity_id": 5,
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 2.2, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

violations[response] {
	id := "S3-2"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	terraform.resources[j].type == resource_type
	object.get(terraform.resources[j].values, "block_public_policy", false) == false

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) block_public_policy should be set to true as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block",
			[id, level, terraform.resources[j].address],
		),
		"severity": level,
		"severity_id": 5,
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 2.2, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"]},
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

	object.get(terraform.resources[j].values, "ignore_public_acls", false) == false

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) ignore_public_acls should be set to true as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block",
			[id, level, terraform.resources[j].address],
		),
		"severity": level,
		"severity_id": 5,
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 2.2, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

violations[response] {
	id := "S3-4"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	object.get(terraform.resources[j].values, "restrict_public_buckets", false) == false

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) restrict_public_buckets should be set to true as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block",
			[id, level, terraform.resources[j].address],
		),
		"severity": level,
		"severity_id": 5,
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 1.3, 2.2, 1.2.1, 1.3.1, 1.3.2, 1.3.4, 1.3.6, 2.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
