package aws.amazon_efs.efs_access_point_enforce_root_directory


test_efs_access_point_enforce_root_directory_valid {
    count(violations) == 0  with input as data.efs_access_point_enforce_root_directory.valid
}

test_efs_access_point_enforce_root_directory_ignore {
    count(violations) == 0  with input as data.efs_access_point_enforce_root_directory.ignore
}

test_efs_access_point_enforce_root_directory_invalid {
    r := violations with input as data.efs_access_point_enforce_root_directory.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "EFS_ACCESS_POINT_ENFORCE_ROOT_DIRECTORY"
    r[_]["finding"]["uid"] = "EFS-1"
}

test_efs_access_point_enforce_root_directory_key_null {
    r := violations with input as data.efs_access_point_enforce_root_directory.key_null
    count(r) == 1
    r[_]["finding"]["title"] = "EFS_ACCESS_POINT_ENFORCE_ROOT_DIRECTORY"
    r[_]["finding"]["uid"] = "EFS-1"
}


