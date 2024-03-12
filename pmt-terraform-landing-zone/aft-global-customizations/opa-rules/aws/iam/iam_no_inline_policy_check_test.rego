package aws.iam.iam_no_inline_policies_check


test_iam_no_inline_policies_check_valid {
    count(violations) == 0  with input as data.iam_no_inline_policies_check.valid
}

test_iam_no_inline_policies_check_invalid_role {
    r := violations with input as data.iam_no_inline_policies_check.invalid_role
    count(r) == 1
    r[_]["finding"]["title"] = "IAM_NO_INLINE_POLICIES_CHECK"
    r[_]["finding"]["uid"] = "IAM-10"
}

test_iam_no_inline_policies_check_invalid_user {
    r := violations with input as data.iam_no_inline_policies_check.invalid_user
    count(r) == 1
    r[_]["finding"]["title"] = "IAM_NO_INLINE_POLICIES_CHECK"
    r[_]["finding"]["uid"] = "IAM-10"
}

test_iam_no_inline_policies_check_invalid_group {
    r := violations with input as data.iam_no_inline_policies_check.invalid_group
    count(r) == 1
    r[_]["finding"]["title"] = "IAM_NO_INLINE_POLICIES_CHECK"
    r[_]["finding"]["uid"] = "IAM-10"
}