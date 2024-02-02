package aws.cloudtrail.multi_region_cloud_trail_enabled


test_multi_region_cloud_trail_enabled_valid {
    count(violations) == 0  with input as data.multi_region_cloud_trail_enabled.valid
}

test_multi_region_cloud_trail_enabled_ignore {
    count(violations) == 0  with input as data.multi_region_cloud_trail_enabled.ignore
}

test_multi_region_cloud_trail_enabled_invalid {
    r := violations with input as data.multi_region_cloud_trail_enabled.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "MULTI_REGION_CLOUD_TRAIL_ENABLED"
    r[_]["finding"]["uid"] = "CLOUDTRAIL-6"
}

test_multi_region_cloud_trail_enabled_key_null {
    r := violations with input as data.multi_region_cloud_trail_enabled.key_null
    count(r) == 1
    r[_]["finding"]["title"] = "MULTI_REGION_CLOUD_TRAIL_ENABLED"
    r[_]["finding"]["uid"] = "CLOUDTRAIL-6"
}


