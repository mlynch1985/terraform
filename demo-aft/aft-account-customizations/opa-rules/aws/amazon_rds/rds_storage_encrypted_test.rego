package aws.amazon_rds.rds_storage_encrypted


test_rds_storage_encrypted_valid {
    count(violations) == 0  with input as data.rds_storage_encrypted.valid
}

test_rds_storage_encrypted_ignore {
    count(violations) == 0  with input as data.rds_storage_encrypted.ignore
}

test_rds_storage_encrypted_no_key {
    r := violations with input as data.rds_storage_encrypted.no_key
    r[_]["finding"]["title"] = "RDS_STORAGE_ENCRYPTED"
    r[_]["finding"]["uid"] = "RDS-7"
}

test_rds_storage_encrypted_invalid {
    r := violations with input as data.rds_storage_encrypted.invalid
    r[_]["finding"]["title"] = "RDS_STORAGE_ENCRYPTED"
    r[_]["finding"]["uid"] = "RDS-7"
}



