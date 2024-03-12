# This AWS Content is provided subject to the terms of the AWS Customer Agreement 
# available at http://aws.amazon.com/agreement or other written agreement between 
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both. 

# Rule Identifier:
#    CLOUDWATCH_LOG_GROUP_ENCRYPTED
#
# Description:
#    Checks if a log group in Amazon CloudWatch Logs is encrypted with an AWS Key Management Service (KMS) key. 
#    The rule is NON_COMPLIANT if no AWS KMS key is configured on the log groups.
#
# Resource Types:
#    aws_cloudwatch_log_group
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.cloudwatch.cloudwatch_log_group_encrypted

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_cloudwatch_log_group"

title := "CLOUDWATCH_LOG_GROUP_ENCRYPTED"

level := "HIGH"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

violations[response] {
	id := "CLOUDWATCH-1"
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
			"DESCRIPTION": "Resource does not have KMS encryption configured. Please provide a kms_key_arn as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 3.4"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
