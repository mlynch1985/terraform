# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   SECRETSMANAGER_USING_CMK
#
# Description:
#    "Checks if all secrets in AWS Secrets Manager are encrypted using the AWS managed key (aws/secretsmanager) or a customer managed key that was created in AWS Key Management Service (AWS KMS). The rule is COMPLIANT if a secret is encrypted using a customer managed key. This rule is NON_COMPLIANT if a secret is encrypted using aws/secretsmanager."
#
# Resource Types:
#    aws_secretsmanager_secret
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.secrets_manager.secretsmanager_using_cmk

import data.terraform.module as terraform
import data.utils as utils

# This is used for output and resource filtering (from mock data)
resource_type := "aws_secretsmanager_secret"

title := "SECRETSMANAGER_USING_CMK"

level := "CRITICAL"

cust_id := "TBD"

owner := "TBD"

is_using_cmk(values) {
	not utils.has_key(values, "kms_key_id")
} else {
	values.kms_key_id == "aws/secretsmanager"
}

violations[response] {
	id := "SECRETS_MANAGER-1"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	is_using_cmk(terraform.resources[j].values)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource does not have KMS CUSTOMER Managed Key encryption configured. Please provide a kms_key_id as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
