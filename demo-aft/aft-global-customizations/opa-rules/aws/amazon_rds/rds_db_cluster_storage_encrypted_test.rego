package aws.amazon_rds.rds_db_cluster_storage_encrypted

test_rds_db_cluster_storage_encrypted_ignore {
    count(violations) == 0 with input as data.rds_db_cluster_storage_encrypted.ignore
}

test_rds_db_cluster_storage_encrypted_valid {
    count(violations) == 0 with input as data.rds_db_cluster_storage_encrypted.valid
}

test_rds_db_cluster_storage_encrypted_no_property {
    r := violations with input as data.rds_db_cluster_storage_encrypted.no_property
    r[_]["finding"]["title"] = "RDS_DB_CLUSTER_STORAGE_ENCRYPTED"
    r[_]["finding"]["uid"] = "RDS-9"
}

test_rds_db_cluster_storage_encrypted_not_enabled {
    r := violations with input as data.rds_db_cluster_storage_encrypted.not_enabled
    r[_]["finding"]["title"] = "RDS_DB_CLUSTER_STORAGE_ENCRYPTED"
    r[_]["finding"]["uid"] = "RDS-9"
}