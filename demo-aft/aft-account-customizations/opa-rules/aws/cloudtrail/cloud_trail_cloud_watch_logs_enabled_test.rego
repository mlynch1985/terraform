package aws.cloudtrail.cloud_trail_cloud_watch_logs_enabled


test_cloud_trail_cloud_watch_logs_enabled_valid {
    count(violations) == 0  with input as data.cloud_trail_cloud_watch_logs_enabled.valid
}

test_cloud_trail_cloud_watch_logs_enabled_ignore {
    count(violations) == 0  with input as data.cloud_trail_cloud_watch_logs_enabled.ignore
}

test_cloud_trail_cloud_watch_logs_enabled_invalid {
    r := violations with input as data.cloud_trail_cloud_watch_logs_enabled.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "CLOUD_TRAIL_CLOUD_WATCH_LOGS_ENABLED"
    r[_]["finding"]["uid"] = "CLOUDTRAIL-1"
}

test_cloud_trail_cloud_watch_logs_enabled_key_null {
    r := violations with input as data.cloud_trail_cloud_watch_logs_enabled.key_null
    count(r) == 1
    r[_]["finding"]["title"] = "CLOUD_TRAIL_CLOUD_WATCH_LOGS_ENABLED"
    r[_]["finding"]["uid"] = "CLOUDTRAIL-1"
}


