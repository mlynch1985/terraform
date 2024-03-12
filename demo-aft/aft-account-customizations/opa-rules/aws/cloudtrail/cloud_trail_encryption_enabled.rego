# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    CLOUD_TRAIL_ENCRYPTION_ENABLED
#
# Description:
#    Checks if AWS CloudTrail is configured to use the server side encryption (SSE) AWS Key Management Service (AWS KMS) encryption.
#    The rule is COMPLIANT if the KmsKeyId is defined.
#
# Resource Types:
#    aws_cloudtrail
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.cloudtrail.cloud_trail_encryption_enabled

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_cloudtrail"

title := "CLOUD_TRAIL_ENCRYPTION_ENABLED"

level := "CRITICAL"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	id := "CLOUDTRAIL-2"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	object.get(terraform.resources[j].values, "kms_key_id", null) == null

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource does not have encryption at rest enabled using KMS CMKs. Please provde a kms_key_id to enable encryption at rest as detailed here https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail#kms_key_id ",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 3.4, 10.5, 10.5.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
