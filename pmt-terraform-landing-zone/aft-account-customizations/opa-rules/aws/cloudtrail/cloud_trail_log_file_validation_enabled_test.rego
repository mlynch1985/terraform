package aws.cloudtrail.cloud_trail_log_file_validation_enabled


test_cloud_trail_log_file_validation_enabled_valid {
    count(violations) == 0  with input as data.cloud_trail_log_file_validation_enabled.valid
}

test_cloud_trail_log_file_validation_enabled_ignore {
    count(violations) == 0  with input as data.cloud_trail_log_file_validation_enabled.ignore
}

test_cloud_trail_log_file_validation_enabled_invalid {
    r := violations with input as data.cloud_trail_log_file_validation_enabled.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "CLOUD_TRAIL_LOG_FILE_VALIDATION_ENABLED"
    r[_]["finding"]["uid"] = "CLOUDTRAIL-3"
}

test_cloud_trail_log_file_validation_enabled_key_null {
    r := violations with input as data.cloud_trail_log_file_validation_enabled.key_null
    count(r) == 1
    r[_]["finding"]["title"] = "CLOUD_TRAIL_LOG_FILE_VALIDATION_ENABLED"
    r[_]["finding"]["uid"] = "CLOUDTRAIL-3"
}


