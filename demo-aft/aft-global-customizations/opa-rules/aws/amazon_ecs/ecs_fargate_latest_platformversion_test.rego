package aws.amazon_ecs.ecs_fargate_latest_platformversion

test_ecs_fargate_latest_platformversion_ignore {
    count(violations) == 0 with input as data.ecs_fargate_latest_platformversion.ignore
}

test_ecs_fargate_latest_platformversion_valid {
    count(violations) == 0 with input as data.ecs_fargate_latest_platformversion.valid   
}

test_ecs_fargate_latest_platformversion_non_valid_version_id {
    r = violations with input as data.ecs_fargate_latest_platformversion.fargate_valid_non_version_id
    count(r) == 1
    r[_]["finding"]["title"] = "ECS_FARGATE_LATEST_PLATFORM_VERSION"
    r[_]["finding"]["uid"] = "ECS-3"
}