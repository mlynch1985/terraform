package aws.amazon_s3.s3_lifecycle_policy_check

test_s3_lifecycle_policy_check_ignore {
	count(violations) == 0 with input as data.s3_lifecycle_policy_check.ignore
}

test_s3_lifecycle_policy_check_valid {
	count(violations) == 0 with input as data.s3_lifecycle_policy_check.valid
}

test_s3_lifecycle_policy_check_not_present {
	r = violations with input as data.s3_lifecycle_policy_check.lifecycle_not_present
	count(r) == 1
	r[_].finding.title = "S3_LIFECYCLE_POLICY_CHECK"
	r[_].finding.uid = "S3-12"
}

test_s3_lifecycle_policy_check_not_valid_transition_days {
	r = violations with input as data.s3_lifecycle_policy_check.not_valid_transition_days
	count(r) == 1
	r[_].finding.title = "S3_LIFECYCLE_POLICY_CHECK"
	r[_].finding.uid = "S3-12"
}

test_s3_lifecycle_policy_check_not_valid_storage_class {
	r = violations with input as data.s3_lifecycle_policy_check.not_valid_storage_class
	count(r) == 1
	r[_].finding.title = "S3_LIFECYCLE_POLICY_CHECK"
	r[_].finding.uid = "S3-12"
}
