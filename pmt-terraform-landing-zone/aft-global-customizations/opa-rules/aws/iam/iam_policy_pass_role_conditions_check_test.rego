package aws.iam.iam_policy_pass_role_conditions_check

test_iam_policy_pass_role_conditions_check_valid {
	count(violations) == 0 with input as data.iam_policy_pass_role_conditions_check.valid
}

test_iam_policy_pass_role_conditions_check_invalid {
	r := violations with input as data.iam_policy_pass_role_conditions_check.passrole_with_wildcard_in_resources
	count(r) == 1
	r[_].finding.title = "IAM_POLICY_PASS_ROLE_CONDITIONS_CHECK"
	r[_].finding.uid = "IAM-4"
}
