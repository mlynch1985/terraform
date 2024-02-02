package aws.amazon_rds.rds_logging_enabled


test_rds_logging_enabled_valid {
    count(violations) == 0  with input as data.rds_logging_enabled.valid
}

test_rds_logging_enabled_ignore {
    count(violations) == 0  with input as data.rds_logging_enabled.ignore
}

test_rds_logging_enabled_no_key {
    r := violations with input as data.rds_logging_enabled.no_key
    r[_]["finding"]["title"] = "RDS_LOGGING_ENABLED"
    r[_]["finding"]["uid"] = "RDS-3"
}

test_rds_logging_enabled_invalid {
    r := violations with input as data.rds_logging_enabled.invalid
    r[_]["finding"]["title"] = "RDS_LOGGING_ENABLED"
    r[_]["finding"]["uid"] = "RDS-3"
}

test_rds_logging_enabled_empty {
    r := violations with input as data.rds_logging_enabled.empty
    r[_]["finding"]["title"] = "RDS_LOGGING_ENABLED"
    r[_]["finding"]["uid"] = "RDS-3"
}



