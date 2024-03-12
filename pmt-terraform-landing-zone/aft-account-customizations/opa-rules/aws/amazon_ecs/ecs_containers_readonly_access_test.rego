package aws.amazon_ecs.ecs_containers_readonly_access

test_ecs_containers_readonly_access_ignore {
    count(violations) == 0 with input as data.ecs_containers_readonly_access.ignore
}

test_ecs_containers_readonly_access_valid {
    count(violations) == 0 with input as data.ecs_containers_readonly_access.valid   
}

test_ecs_containers_readonly_access_one_not_valid {
    r = violations with input as data.ecs_containers_readonly_access.one_not_valid
    count(r) == 1 
    r[_]["finding"]["title"] = "ECS_CONTAINERS_READONLY_ACCESS"
    r[_]["finding"]["uid"] = "ECS-2"
}

test_ecs_containers_readonly_access_two_not_valid {
    r = violations with input as data.ecs_containers_readonly_access.two_not_valid 
    count(r) == 1
    r[_]["finding"]["title"] = "ECS_CONTAINERS_READONLY_ACCESS"
    r[_]["finding"]["uid"] = "ECS-2"
}