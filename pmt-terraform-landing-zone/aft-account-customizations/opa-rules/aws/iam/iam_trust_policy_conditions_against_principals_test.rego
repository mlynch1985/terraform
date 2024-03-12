package aws.iam.iam_trust_policy_conditions_check

test_iam_trust_policy_conditions_check_valid {
	count(violations) == 0 with input as data.iam_trust_policy_conditions_check.valid
}

test_iam_trust_policy_conditions_check_invalid {
	r := violations with input as data.iam_trust_policy_conditions_check.invalid
	count(r) == 1
	r[_].finding.title = "IAM_TRUST_POLICY_CONDITIONS_CHECK"
	r[_].finding.uid = "IAM-8"
}
