package aws.aws_kms.cmk_backing_key_rotation_enabled


test_cmk_backing_key_rotation_enabled_valid {
    count(violations) == 0  with input as data.cmk_backing_key_rotation_enabled.valid
}

test_cmk_backing_key_rotation_enabled_ignore {
    count(violations) == 0  with input as data.cmk_backing_key_rotation_enabled.ignore
}

test_cmk_backing_key_rotation_enabled_invalid {
    r := violations with input as data.cmk_backing_key_rotation_enabled.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "CMK_BACKING_KEY_ROTATION_ENABLED"
    r[_]["finding"]["uid"] = "KMS-1"
}

test_cmk_backing_key_rotation_enabled_no_rotation {
    r := violations with input as data.cmk_backing_key_rotation_enabled.no_rotation
    count(r) == 1
    r[_]["finding"]["title"] = "CMK_BACKING_KEY_ROTATION_ENABLED"
    r[_]["finding"]["uid"] = "KMS-1"
}


