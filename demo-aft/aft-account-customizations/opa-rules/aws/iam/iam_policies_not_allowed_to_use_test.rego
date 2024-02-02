package aws.iam.iam_policies_not_allowed_to_use

test_iam_policies_not_allowed_to_use_valid {
	count(violations) == 0 with input as data.iam_policies_not_allowed_to_use.valid
}

test_iam_policies_not_allowed_to_use_ignore {
	count(violations) == 0 with input as data.iam_policies_not_allowed_to_use.ignore
}

test_iam_policies_not_allowed_to_use_invalid {
	r := violations with input as data.iam_policies_not_allowed_to_use.invalid
	count(r) == 1
	r[_].finding.title = "IAM_POLICIES_NOT_ALLOWED_TO_USE"
	r[_].finding.uid = "IAM-1"
}

test_iam_policies_not_allowed_to_use_invalid_multiple {
	r := violations with input as data.iam_policies_not_allowed_to_use.invalid_multiple
	count(r) == 1
	r[_].finding.title = "IAM_POLICIES_NOT_ALLOWED_TO_USE"
	r[_].finding.uid = "IAM-1"
}
