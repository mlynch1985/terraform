# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    ENCRYPTED_VOLUMES
#
# Description:
#    Checks if the EBS volumes that are in an attached state are encrypted.
#    If you specify the ID of a KMS key for encryption using the kmsId parameter, the rule checks if the EBS volumes in an attached state are encrypted with that KMS key.
#
# Resource Types:
#    aws_ebs_volume
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.amazon_ec2.encrypted_volumes

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_ebs_volume"

title := "ENCRYPTED_VOLUMES"

level := "HIGH"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

is_encrypted(res) {
	not object.get(res.values, "encrypted", false)
} else {
	object.get(res.values, "kms_key_id", null) == null
}

violations[response] {
	id := "EC2-5"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	is_encrypted(terraform.resources[j])

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource does not have KMS encryption configured. Please provide a kms_key_id and set encrypted to true as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume#encrypted",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 3.4, 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
