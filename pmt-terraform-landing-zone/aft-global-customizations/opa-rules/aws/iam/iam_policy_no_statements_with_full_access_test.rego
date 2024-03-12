package aws.iam.iam_policy_no_statements_with_full_access

test_iam_policy_no_statements_with_full_access_valid_iam_policies {
    count(violations) == 0  with input as data.iam_policy_no_statements_with_full_access.valid_iam_policies
}

test_iam_policy_no_statements_with_full_access_invalid_iam_group_policy {
    r := violations with input as data.iam_policy_no_statements_with_full_access.invalid_iam_group_policy
    count(r) == 4
    r[_]["finding"]["title"] = "IAM_POLICY_NO_STATEMENTS_WITH_FULL_ACCESS"
    r[_]["finding"]["uid"] = "IAM.21"
}
