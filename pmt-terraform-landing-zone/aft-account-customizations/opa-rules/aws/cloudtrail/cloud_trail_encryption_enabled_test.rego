package aws.cloudtrail.cloud_trail_encryption_enabled


test_cloud_trail_encryption_enabled_valid {
    count(violations) == 0  with input as data.cloud_trail_encryption_enabled.valid
}

test_cloud_trail_encryption_enabled_ignore {
    count(violations) == 0  with input as data.cloud_trail_encryption_enabled.ignore
}

test_cloud_trail_encryption_enabled_invalid {
    r := violations with input as data.cloud_trail_encryption_enabled.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "CLOUD_TRAIL_ENCRYPTION_ENABLED"
    r[_]["finding"]["uid"] = "CLOUDTRAIL-2"
}

test_cloud_trail_encryption_enabled_key_null {
    r := violations with input as data.cloud_trail_encryption_enabled.key_null
    count(r) == 1
    r[_]["finding"]["title"] = "CLOUD_TRAIL_ENCRYPTION_ENABLED"
    r[_]["finding"]["uid"] = "CLOUDTRAIL-2"
}


