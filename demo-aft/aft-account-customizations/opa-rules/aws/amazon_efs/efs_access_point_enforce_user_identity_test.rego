package aws.amazon_efs.efs_access_point_enforce_user_identity


test_efs_access_point_enforce_user_identity_valid {
    count(violations) == 0  with input as data.efs_access_point_enforce_user_identity.valid
}

test_efs_access_point_enforce_user_identity_ignore {
    count(violations) == 0  with input as data.efs_access_point_enforce_user_identity.ignore
}

test_efs_access_point_enforce_user_identity_invalid {
    r := violations with input as data.efs_access_point_enforce_user_identity.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "EFS_ACCESS_POINT_ENFORCE_USER_IDENTITY"
    r[_]["finding"]["uid"] = "EFS-2"
}

test_efs_access_point_enforce_user_identity_key_null {
    r := violations with input as data.efs_access_point_enforce_user_identity.key_null
    count(r) == 1
    r[_]["finding"]["title"] = "EFS_ACCESS_POINT_ENFORCE_USER_IDENTITY"
    r[_]["finding"]["uid"] = "EFS-2"
}


