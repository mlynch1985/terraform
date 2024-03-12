# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    ECR_PRIVATE_IMAGE_SCANNING_ENABLED
#
# Description:
# Checks if a private Amazon Elastic Container Registry (ECR) repository has image scanning enabled.
# The rule is NON_COMPLIANT if image scanning is not enabled for the private ECR repository.
#
# Resource Types:
#    aws_ecr_repository
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_ecr.ecr_private_image_scanning_enabled

import data.frameworks as frameworks
import data.ignore_rules as ignore_rules
import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_ecr_repository"

level := "CRITICAL"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

title := "ECR_PRIVATE_IMAGE_SCANNING_ENABLED"

has_image_scanning_configuration(values) {
	# print("has_key",utils.has_key(values, "image_scanning_configuration"))
	not utils.has_key(values, "image_scanning_configuration")
} else {
	s := object.get(values, "image_scanning_configuration", [])

	# print(object.get(s,"scan_on_push", false))
	object.get(s, "scan_on_push", false) == false
}

violations[response] {
	id := "ECR-1"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	has_image_scanning_configuration(terraform.resources[j].values)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource Image scanning for ECR repository should be enabled. https://docs.aws.amazon.com/config/latest/developerguide/ecr-private-image-scanning-enabled.html",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 11.2.3, 6.3.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
