package aws.aws_securityhub.securityhub_enabled

test_securityhub_enabled_valid {
    count(violations) == 0  with input as data.securityhub_enabled.valid
}

test_securityhub_enabled_ignore {
    count(violations) == 0  with input as data.securityhub_enabled.ignore
}

test_securityhub_enabled_invalid {
    r := violations with input as data.securityhub_enabled.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "SECURITYHUB_ENABLED"
    r[_]["finding"]["uid"] = "SECURITYHUB-1"
}
