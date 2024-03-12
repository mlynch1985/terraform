package aws.iam.iam_policy_no_wildcard_resources

test_iam_policy_no_wildcard_resources_no_wildcards {
	count(violations) == 0 with input as data.iam_policy_no_wildcard_resources.no_wildcards
}

test_iam_policy_no_wildcard_resources_all_with_wildcard_resources {
	r := violations with input as data.iam_policy_no_wildcard_resources.all_wildcards
	count(r) == 7
	r[_].finding.title = "IAM_POLICY_NO_WILDCARD_RESOURCES"
	r[_].finding.uid = "IAM-3"
}
