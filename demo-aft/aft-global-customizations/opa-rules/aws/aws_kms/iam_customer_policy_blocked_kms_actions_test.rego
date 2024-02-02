package aws.aws_kms.iam_customer_policy_blocked_kms_actions


test_iam_customer_policy_blocked_kms_actions_ignore {
    count(violations) == 0  with input as data.iam_customer_policy_blocked_kms_actions.ignore
}

test_iam_customer_policy_blocked_kms_actions_valid {
    count(violations) == 0  with input as data.iam_customer_policy_blocked_kms_actions.valid
}

test_iam_customer_policy_blocked_kms_actions_invalid_all {
    r := violations with input as data.iam_customer_policy_blocked_kms_actions.invalid_all
    count(r) == 1
    r[_]["finding"]["title"] = "IAM_CUSTOMER_POLICY_BLOCKED_KMS_ACTIONS"
    r[_]["finding"]["uid"] = "KMS-2"
}
test_iam_customer_policy_blocked_kms_actions_invalid {
    r := violations with input as data.iam_customer_policy_blocked_kms_actions.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "IAM_CUSTOMER_POLICY_BLOCKED_KMS_ACTIONS"
    r[_]["finding"]["uid"] = "KMS-2"
}

test_iam_customer_policy_blocked_kms_actions_aws_iam_policy_invalid {
    r := violations with input as data.iam_customer_policy_blocked_kms_actions.aws_iam_policy_invalid
    count(r) == 1
    r[_]["finding"]["title"] = "IAM_CUSTOMER_POLICY_BLOCKED_KMS_ACTIONS"
    r[_]["finding"]["uid"] = "KMS-2"
}
