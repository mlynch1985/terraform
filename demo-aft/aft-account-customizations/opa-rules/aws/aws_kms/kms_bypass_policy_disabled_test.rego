package aws.aws_kms.kms_bypass_policy_disabled


test_kms_bypass_policy_disabled_valid {
    count(violations) == 0  with input as data.kms_bypass_policy_disabled.valid
}

test_kms_bypass_policy_disabled_ignore {
    count(violations) == 0  with input as data.kms_bypass_policy_disabled.ignore
}

test_kms_bypass_policy_disabled_invalid {
    r := violations with input as data.kms_bypass_policy_disabled.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "KMS_BYPASS_POLICY_DISABLED"
    r[_]["finding"]["uid"] = "KMS-4"
}