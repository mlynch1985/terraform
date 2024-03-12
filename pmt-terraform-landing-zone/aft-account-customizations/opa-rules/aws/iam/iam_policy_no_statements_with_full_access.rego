# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    IAM_POLICY_NO_STATEMENTS_WITH_FULL_ACCESS
#
# Description:
# Ensure IAM Actions are restricted to only those actions that are needed.
# Allowing users to have more privileges than needed to complete a task may violate the principle of least privilege and separation of duties.
#
# Resource Types:
#    aws_iam_policy, aws_iam_group_policy, aws_iam_role_policy, aws_iam_user_policy
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.iam.iam_policy_no_statements_with_full_access

import data.terraform.module as terraform
import data.utils as utils

import future.keywords

title := "IAM_POLICY_NO_STATEMENTS_WITH_FULL_ACCESS"

level := "HIGH"

cust_id := "Bofa-AxiaMed"
owner := "UNKNOWN"

iam_resources := [
	"aws_iam_policy",
	"aws_iam_group_policy",
	"aws_iam_role_policy",
	"aws_iam_user_policy",
]

has_full_access(action) if {
	action == "*"
}

has_full_access(action) if {
	action[_] == "*"
}

has_full_access(action) if {
	regex.split(":", action)[1] == "*"
}

has_full_access(action) if {
	regex.split(":", action[_])[1] == "*"
}


violations contains response if {
	id := "IAM.21"

	some k

	terraform.resources[j].type in iam_resources

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	policy := object.get(terraform.resources[j].values, "policy", {})
	policy_json := json.unmarshal(policy)
	statements := object.get(policy_json, "Statement", {})

	statement := statements[k]
	effect 	:=	object.get(statement, "Effect", "")
	actions := object.get(statement, "Action", ["Service:none"])
	# conditions := object.get(statement, "Condition", [])
	# principals := object.get(statement, "Principal", [])

	not effect == "Deny"
	has_full_access(actions)
	# count(principals) == 0
	# count(conditions) == 0

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": "IAM customer managed policies (%s) that you create should not allow wildcard actions for services",
		},
		"compliance": {
			"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1.1, 7.1.2, 7.2.1, 7.2.2"]
		},
		"Related requirements": ["NIST.800-53.r5 AC-2, NIST.800-53.r5 AC-2(1), NIST.800-53.r5 AC-3, NIST.800-53.r5 AC-3(15), NIST.800-53.r5 AC-3(7), NIST.800-53.r5 AC-5, NIST.800-53.r5 AC-6, NIST.800-53.r5 AC-6(10), NIST.800-53.r5 AC-6(2), NIST.800-53.r5 AC-6(3)"],
		"Severity": "Low",
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
		"Remediation": "To remediate this issue, update your IAM policies so that they do not allow full \"*\" administrative privileges. For details about how to edit an IAM policy, see Editing IAM policies (https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-edit.html) in the IAM User Guide."
	})
}


violations contains response if {
	id := "IAM-21"

	some k

	terraform.resources[j].type in iam_resources

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	policy := object.get(terraform.resources[j].values, "policy", {})
	policy_json := json.unmarshal(policy)
	statements := object.get(policy_json, "Statement", {})

	statement := statements[k]
	effect 	:=	object.get(statement, "Effect", "")
	notAction := object.get(statement, "NotAction", ["Service:none"])
	# conditions := object.get(statement, "Condition", [])
	# principals := object.get(statement, "Principal", [])

	not effect == "Deny"
	has_full_access(notAction)
	# count(principals) == 0
	# count(conditions) == 0

	response := terraform.ocsf_response(id, title, {
		"message": sprintf(
			"ID %s %s: IAM customer managed policies (%s) that you create should not allow wildcard actions for services",
			[id, level, terraform.resources[j].address],
		),
		"compliance": {
			"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1.1, 7.1.2, 7.2.1, 7.2.2"]
		},
		"Related requirements": ["NIST.800-53.r5 AC-2, NIST.800-53.r5 AC-2(1), NIST.800-53.r5 AC-3, NIST.800-53.r5 AC-3(15), NIST.800-53.r5 AC-3(7), NIST.800-53.r5 AC-5, NIST.800-53.r5 AC-6, NIST.800-53.r5 AC-6(10), NIST.800-53.r5 AC-6(2), NIST.800-53.r5 AC-6(3)"],
		"Severity": "Low",
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
		"Remediation": "To remediate this issue, update your IAM policies so that they do not allow full \"*\" administrative privileges. For details about how to edit an IAM policy, see Editing IAM policies (https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-edit.html) in the IAM User Guide."
	})
}
