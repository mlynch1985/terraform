package aws.secrets_manager.secretsmanager_using_cmk

test_secretsmanager_using_cmk_valid {
    count(violations) == 0  with input as data.secretsmanager_using_cmk.valid
}

test_secretsmanager_using_cmk_ignore {
    count(violations) == 0  with input as data.secretsmanager_using_cmk.ignore
}

test_secretsmanager_using_cmk_invalid0 {
    r := violations with input as data.secretsmanager_using_cmk.invalid0
    count(r) == 1
    r[_]["finding"]["title"] = "SECRETSMANAGER_USING_CMK"
    r[_]["finding"]["uid"] = "SECRETS_MANAGER-1"
}
test_secretsmanager_using_cmk_invalid1 {
    r := violations with input as data.secretsmanager_using_cmk.invalid1
    count(r) == 1
    r[_]["finding"]["title"] = "SECRETSMANAGER_USING_CMK"
    r[_]["finding"]["uid"] = "SECRETS_MANAGER-1"
}
