# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    CMK_BACKING_KEY_ROTATION_ENABLED
#
# Description:
#    Checks whether Amazon Redshift clusters require TLS/SSL encryption to connect to SQL clients.
#    The rule is NON_COMPLIANT if any Amazon Redshift cluster has parameter require_SSL not set to true.
#
# Resource Types:
#    aws_kms_key
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.aws_kms.cmk_backing_key_rotation_enabled

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_kms_key"

title := "CMK_BACKING_KEY_ROTATION_ENABLED"

level := "CRITICAL"

violations[response] {
	id := "KMS-1"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not object.get(terraform.resources[j].values, "enable_key_rotation", false)

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) rotation should be enabled. Please set enable_key_rotation to true as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#enable_key_rotation",
			[id, level, terraform.resources[j].address],
		),
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 3.6.4"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
