package aws.iam.iam_roles_only_allowed_roles_on_root_path

test_iam_roles_only_allowed_roles_on_root_path_valid {
    count(violations) == 0  with input as data.iam_roles_only_allowed_roles_on_root_path.valid
}

test_iam_roles_only_allowed_roles_on_root_path_invalid {
    r := violations with input as data.iam_roles_only_allowed_roles_on_root_path.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "IAM_ROLES_ONLY_CORE_ROLES_ALLOWED_ON_ROOT_PATH"
    r[_]["finding"]["uid"] = "IAM-6"
}

