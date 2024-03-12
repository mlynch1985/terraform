package aws.amazon_efs.efs_encrypted_check


test_efs_encrypted_check_valid {
    count(violations) == 0  with input as data.efs_encrypted_check.valid
}

test_efs_encrypted_check_ignore {
    count(violations) == 0  with input as data.efs_encrypted_check.ignore
}

test_efs_encrypted_check_invalid {
    r := violations with input as data.efs_encrypted_check.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "EFS_ENCRYPTED_CHECK"
    r[_]["finding"]["uid"] = "EFS-3"
}

test_efs_encrypted_check_key_null {
    r := violations with input as data.efs_encrypted_check.key_null
    count(r) == 1
    r[_]["finding"]["title"] = "EFS_ENCRYPTED_CHECK"
    r[_]["finding"]["uid"] = "EFS-3"
}

test_efs_encrypted_check_kms_null {
    r := violations with input as data.efs_encrypted_check.kms_null
    count(r) == 1
    r[_]["finding"]["title"] = "EFS_ENCRYPTED_CHECK"
    r[_]["finding"]["uid"] = "EFS-3"
}

test_efs_encrypted_check_enc_false {
    r := violations with input as data.efs_encrypted_check.enc_false
    count(r) == 1
    r[_]["finding"]["title"] = "EFS_ENCRYPTED_CHECK"
    r[_]["finding"]["uid"] = "EFS-3"
}


