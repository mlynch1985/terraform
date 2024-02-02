# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    IAM_INLINE_POLICY_BLOCKED_KMS_ACTIONS
#
# Description:
# Checks if the inline policies attached to your IAM users, roles, and groups do not allow blocked actions on all AWS KMS keys.
# The rule is NON_COMPLIANT if any blocked action is allowed on all AWS KMS keys in an inline policy.
#
# Note:
# This rule when it's implemented via AWS Config it allows to exclude a role if it is only assumable by organization management account.
# However, when the rule is implemented as a Terraform preventive control via OPA, there is no way to know if the AWS account belongs to an AWS organization
# and if so, what's the management account of the organization.
#
# Resource Types:
#    aws_iam_group_policy
#    aws_iam_role_policy
#    aws_iam_user_policy
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.aws_kms.iam_inline_policy_blocked_kms_actions

import data.terraform.module as terraform
import data.utils as utils
import data.ignore_rules_iam as opa_ignore_id

iam_resource_types = [
	"aws_iam_group_policy",
	"aws_iam_role_policy",
	"aws_iam_user_policy",
]

level := "HIGH"

title := "IAM_INLINE_POLICY_BLOCKED_KMS_ACTIONS"

valid_iam_actions(actions, blocked_actions_patterns) {
	statementaction := actions[_]
	regex.match(blocked_actions_patterns[_], statementaction)
}

valid_iam_actions(actions, blocked_actions_patterns) {
	regex.match(blocked_actions_patterns[_], actions)
}

violations[response] {
	id := "KMS-3"

	utils.array_contains(iam_resource_types, terraform.resources[j].type)

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	blocked_actions_patterns := object.get(data.variables, "blocked_actions_patterns", [])
	count(blocked_actions_patterns) > 0

	policy := object.get(terraform.resources[j].values, "policy", {})
	policydoc := json.unmarshal(policy)
	statements := object.get(policydoc, "Statement", {})

	statement := statements[_]
	effect := object.get(statement, "Effect", "")
	lower(effect) == "allow"
	actions := object.get(statement, "Action", "")
	valid_iam_actions(actions, blocked_actions_patterns)

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: Resource (%s) contains actions (%s) for KMS which are not allowed. Please, review the IAM polcicy and remove the non-allowed KMS action from the IAM policy.",
			[id, level, terraform.resources[j].address, blocked_actions_patterns],
		),
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 3.5.2, 7.1.1, 7.1.2, 7.2.1, 7.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
