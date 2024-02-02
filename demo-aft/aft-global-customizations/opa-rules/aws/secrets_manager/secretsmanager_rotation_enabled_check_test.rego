package aws.secrets_manager.secretsmanager_rotation_enabled_check

test_secretsmanager_rotation_enabled_check_valid {
    count(violations) == 0  with input as data.secretsmanager_rotation_enabled_check.valid
}

test_secretsmanager_rotation_enabled_check_ignore {
    count(violations) == 0  with input as data.secretsmanager_rotation_enabled_check.ignore
}

test_secretsmanager_rotation_enabled_check_invalid {
    r := violations with input as data.secretsmanager_rotation_enabled_check.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "SECRETSMANAGER_ROTATION_ENABLED_CHECK"
    r[_]["finding"]["uid"] = "SECRETS_MANAGER-2"
}

test_secretsmanager_rotation_enabled_check_invalid_no_rotation_days {
    r := violations with input as data.secretsmanager_rotation_enabled_check.invalid_no_rotation_days
    count(r) == 1
    r[_]["finding"]["title"] = "SECRETSMANAGER_ROTATION_ENABLED_CHECK"
    r[_]["finding"]["uid"] = "SECRETS_MANAGER-2"
}