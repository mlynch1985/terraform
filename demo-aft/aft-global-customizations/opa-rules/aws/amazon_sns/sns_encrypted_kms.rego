# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    SNS_ENCRYPTED_KMS
#
# Description:
#     Checks if Amazon SNS topic is encrypted with AWS Key Management Service (AWS KMS).
#     The rule is NON_COMPLIANT if the Amazon SNS topic is not encrypted with AWS KMS.
#     The rule is also NON_COMPLIANT when encrypted KMS key is not present in kms_master_key_id input parameter.
#
# Resource Types:
#    aws_sns_topic
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_sns.sns_encrypted_kms

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_sns_topic"

title := "SNS_ENCRYPTED_KMS"

id := "SNS-1"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	utils.empty_or_null(object.get(terraform.resources[j].values, "kms_master_key_id", null))

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) does not have KMS encryption configured. Please provide a kms_master_key_id as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic.html#kms_master_key_id",
				[terraform.resources[j].address],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 3.4, 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
