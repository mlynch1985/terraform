package aws.amazon_ecs.ecs_containers_nonprivileged

test_ecs_containers_nonprivileged_ignore {
    count(violations) == 0 with input as data.ecs_containers_nonprivileged.ignore
}

test_ecs_containers_nonprivileged_valid {
    count(violations) == 0 with input as data.ecs_containers_nonprivileged.valid   
}

test_ecs_containers_nonprivileged_one_priviledge {
    r = violations with input as data.ecs_containers_nonprivileged.one_priviledge
    count(r) == 1 
    r[_]["finding"]["title"] = "ECS_CONTAINERS_NONPRIVILEGED"
    r[_]["finding"]["uid"] = "ECS-1"
}

test_ecs_containers_nonprivileged_two_priviledge {
    r = violations with input as data.ecs_containers_nonprivileged.two_priviledge
    count(r) == 1 
    r[_]["finding"]["title"] = "ECS_CONTAINERS_NONPRIVILEGED"
    r[_]["finding"]["uid"] = "ECS-1"
}