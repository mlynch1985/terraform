package aws.cloudwatch.cloudwatch_log_group_encrypted


test_cloudwatch_log_group_encrypted_valid {
    count(violations) == 0  with input as data.cloudwatch_log_group_encrypted.valid
}

test_cloudwatch_log_group_encrypted_ignore {
    count(violations) == 0  with input as data.cloudwatch_log_group_encrypted.ignore
}

test_cloudwatch_log_group_encrypted_invalid {
    r := violations with input as data.cloudwatch_log_group_encrypted.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "CLOUDWATCH_LOG_GROUP_ENCRYPTED"
    r[_]["finding"]["uid"] = "CLOUDWATCH-1"
}

test_cloudwatch_log_group_encrypted_key_null {
    r := violations with input as data.cloudwatch_log_group_encrypted.key_null
    count(r) == 1
    r[_]["finding"]["title"] = "CLOUDWATCH_LOG_GROUP_ENCRYPTED"
    r[_]["finding"]["uid"] = "CLOUDWATCH-1"
}


