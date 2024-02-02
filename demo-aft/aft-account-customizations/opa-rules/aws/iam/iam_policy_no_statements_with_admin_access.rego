# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    IAM_POLICY_NO_STATEMENTS_WITH_ADMIN_ACCESS
#
# Description:
# AWS Identity and Access Management (IAM) can help you incorporate the principles of least privilege and separation of duties with
# access permissions and authorizations, restricting policies from containing "Effect": "Allow" with "Action": "*" over "Resource": "*".
# Allowing users to have more privileges than needed to complete a task may violate the principle of least privilege and separation of duties.
#
# Resource Types:
#    aws_iam_policy, aws_iam_group_policy, aws_iam_role_policy,
#    aws_iam_user_policy, aws_s3_bucket_policy, aws_kms_key_policy
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.iam.iam_policy_no_statements_with_admin_access

import data.terraform.module as terraform
import data.utils as utils

import future.keywords

title := "IAM_POLICY_NO_STATEMENTS_WITH_ADMIN_ACCESS"

level := "HIGH"

cust_id := "Bofa-AxiaMed"
owner := "UNKNOWN"

iam_resources := [
	"aws_iam_policy",
	"aws_iam_group_policy",
	"aws_iam_role_policy",
	"aws_iam_user_policy",
	"aws_s3_bucket_policy",
	"aws_kms_key_policy",
]


has_full_access(statement) if {
	statement == "*"
}

has_full_access(statement) if {
	statement[_] == "*"
}

has_full_access(statement) if {
	count(statement) == 0
}


violations contains response if {
	id := "IAM-11"

	some k

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	terraform.resources[j].type in iam_resources

	policy := object.get(terraform.resources[j].values, "policy", {})
	policy_json := json.unmarshal(policy)
	statements := object.get(policy_json, "Statement", {})

	statement := statements[k]
	effect 	:=	object.get(statement, "Effect", "Allow")
	actions := object.get(statement, "Action", [])
	# conditions := object.get(statement, "Condition", [])
	# principals := object.get(statement, "Principal", [])

	not effect == "Deny"
	has_full_access(actions)
	# has_full_access(principals)
	# count(conditions) == 0

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": "Resource should not allow * for actions for all principals without condition statements. Please provide a condition statement to tighten scope",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 7.1.1, 7.1.2, 7.2.1, 7.2.2"]},
		"Related requirements": "PCI DSS v3.2.1/7.2.1, CIS AWS Foundations Benchmark v1.2.0/1.22, CIS AWS Foundations Benchmark v1.4.0/1.16, NIST.800-53.r5 AC-2, NIST.800-53.r5 AC-2(1), NIST.800-53.r5 AC-3, NIST.800-53.r5 AC-3(15), NIST.800-53.r5 AC-3(7), NIST.800-53.r5 AC-5, NIST.800-53.r5 AC-6, NIST.800-53.r5 AC-6(10), NIST.800-53.r5 AC-6(2), NIST.800-53.r5 AC-6(3)",
		"Severity": "High",
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
		"Remediation": "To modify your IAM policies so that they do not allow full \"*\" administrative privileges, see Editing IAM policies (https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-edit.html) in the IAM User Guide."
	})
}
