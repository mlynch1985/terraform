# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    EFS_ENCRYPTED_CHECK
#
# Description:
#    Checks if Amazon Elastic File System (Amazon EFS) is configured to encrypt the file data using AWS Key Management Service (AWS KMS).
#    The rule is NON_COMPLIANT if the encrypted key is set to false on DescribeFileSystems or if the KmsKeyId key on DescribeFileSystems does not match the KmsKeyId parameter.
#
# Resource Types:
#    aws_efs_file_system
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.amazon_efs.efs_encrypted_check

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_efs_file_system"

title := "EFS_ENCRYPTED_CHECK"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

is_encrypt(values) {
	not object.get(values, "encrypted", false)
} else {
	object.get(values, "kms_key_id", null) == null
}

violations[response] {
	id := "EFS-3"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	is_encrypt(terraform.resources[j].values)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource does not have the key encrypted set to true. Please provide a kms_key_id and set encrypted to true as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 3.4, 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
