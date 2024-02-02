# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    IAM_CUSTOMER_POLICY_BLOCKED_KMS_ACTIONS
#
# Description:
# Checks if the managed AWS Identity and Access Management (IAM) policies that you create do not allow blocked actions on AWS KMS) keys.
# The rule is NON_COMPLIANT if any blocked action is allowed on AWS KMS keys by the managed IAM policy.
#
# Note:
# This rule when it's implemented via AWS Config it allows to exclude the evaluation of IAM policies used as permissions boundaries.
# However, when it's implemented as a Terraform preventive control via OPA, in case the IAM policy used as a permission boundary already exists,
# it's not possible to check the actions within that policy.
#
# Resource Types:
#    aws_iam_policy
#    aws_iam_policy_document
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.aws_kms.iam_customer_policy_blocked_kms_actions

import data.terraform.module as terraform
import data.utils as utils
import data.ignore_rules_iam as opa_ignore_id

iam_resource_types = [
	"aws_iam_policy",
	"aws_iam_policy_document",
]

title := "IAM_CUSTOMER_POLICY_BLOCKED_KMS_ACTIONS"

level := "HIGH"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

check_iam_kms_actions(tf_resource, blocked_actions_patterns) {
	terraform.resources[j].type == "aws_iam_policy_document"
	statements := object.get(terraform.resources[j].values, "statement", {})

	statement := statements[_]
	effect := object.get(statement, "effect", "")
	lower(effect) == "allow"
	actions := object.get(statement, "actions", "")

	valid_iam_actions(actions, blocked_actions_patterns)
}

check_iam_kms_actions(tf_resource, blocked_actions_patterns) {
	terraform.resources[j].type != "aws_iam_policy_document"

	policy := object.get(terraform.resources[j].values, "policy", {})
	policydoc := json.unmarshal(policy)
	statements := object.get(policydoc, "Statement", {})

	statement := statements[_]
	effect := object.get(statement, "Effect", "")
	lower(effect) == "allow"
	actions := object.get(statement, "Action", "")

	valid_iam_actions(actions, blocked_actions_patterns)
}

valid_iam_actions(actions, blocked_actions_patterns) {
	statementaction := actions[_]
	regex.match(blocked_actions_patterns[_], statementaction)
}

valid_iam_actions(actions, blocked_actions_patterns) {
	regex.match(blocked_actions_patterns[_], actions)
}

violations[response] {
	id := "KMS-2"

	utils.array_contains(iam_resource_types, terraform.resources[j].type)

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	blocked_actions_patterns := object.get(data.variables, "blocked_actions_patterns", [])
	count(blocked_actions_patterns) > 0

	check_iam_kms_actions(terraform.resources[j], blocked_actions_patterns)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": "Resource contains actions for KMS which are not allowed. Please review the IAM polcicy and remove the non-allowed KMS action from the IAM policy.",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 3.5.2, 7.1.1, 7.1.2, 7.2.1, 7.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
