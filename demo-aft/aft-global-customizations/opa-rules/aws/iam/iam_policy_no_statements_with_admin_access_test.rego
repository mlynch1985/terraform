package aws.iam.iam_policy_no_statements_with_admin_access

test_iam_policy_no_statements_with_admin_access_valid_iam_policies {
    count(violations) == 0  with input as data.iam_policy_no_statements_with_admin_access.valid_iam_policies
}


test_iam_policy_no_statements_with_admin_access_invalid_iam_policies {
    r := violations with input as data.iam_policy_no_statements_with_admin_access.invalid_iam_policies
    count(r) == 4
    r[_]["finding"]["title"] = "IAM_POLICY_NO_STATEMENTS_WITH_ADMIN_ACCESS"
    r[_]["finding"]["uid"] = "IAM-11"
}