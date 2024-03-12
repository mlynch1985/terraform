# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    EC2_EBS_ENCRYPTION_BY_DEFAULT
#
# Description:
#    Checks if the EBS volumes that are in an attached state are encrypted.
#    If you specify the ID of a KMS key for encryption using the kmsId parameter, the rule checks if the EBS volumes in an attached state are encrypted with that KMS key.
#
# Resource Types:
#    aws_ebs_encryption_by_default
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_ec2.ec2_ebs_encryption_by_default

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_ebs_encryption_by_default"

title := "EC2_EBS_ENCRYPTION_BY_DEFAULT"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	id := "EC2-1"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	not object.get(terraform.resources[j].values, "enabled", true)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource should not have encryption disabled. Please set default encryption to true as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_encryption_by_default",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 3.4, 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
