package aws.amazon_ecs.ecs_task_definition_nonroot_user

test_ecs_task_definition_nonroot_user_ignore {
    count(violations) == 0 with input as data.ecs_task_definition_nonroot_user.ignore
}

test_ecs_task_definition_nonroot_user_valid {
    count(violations) == 0 with input as data.ecs_task_definition_nonroot_user.valid
}

test_ecs_task_definition_nonroot_user_not_present {
    r = violations with input as data.ecs_task_definition_nonroot_user.user_not_present
    count(r) == 1
    r[_]["finding"]["title"] = "ECS_TASK_DEFINITION_NONROOT_USER"
    r[_]["finding"]["uid"] = "ECS-5"
}

test_ecs_task_definition_nonroot_user_root {
    r = violations with input as data.ecs_task_definition_nonroot_user.root
    count(r) == 1
    r[_]["finding"]["title"] = "ECS_TASK_DEFINITION_NONROOT_USER"
    r[_]["finding"]["uid"] = "ECS-5"
}