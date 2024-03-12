package aws.amazon_ecs.ecs_no_environment_secrets

test_ecs_no_environment_secrets_ignore {
    count(violations) == 0 with input as data.ecs_no_environment_secrets.ignore
}

test_ecs_no_environment_secrets_valid {
    count(violations) == 0 with input as data.ecs_no_environment_secrets.valid
}

test_ecs_no_environment_secrets_password {
    r = violations with input as data.ecs_no_environment_secrets.password
    count(r) == 1
    r[_]["finding"]["title"] = "ECS_NO_ENVIRONMENT_SECRETS"
    r[_]["finding"]["uid"] = "ECS-4"
}