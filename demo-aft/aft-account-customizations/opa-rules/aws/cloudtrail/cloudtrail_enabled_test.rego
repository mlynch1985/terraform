package aws.cloudtrail.cloudtrail_enabled


test_cloudtrail_enabled_valid {
    count(violations) == 0  with input as data.cloudtrail_enabled.valid
}

test_cloudtrail_enabled_ignore {
    count(violations) == 0  with input as data.cloudtrail_enabled.ignore
}

test_cloudtrail_enabled_invalid {
    r := violations with input as data.cloudtrail_enabled.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "CLOUD_TRAIL_ENABLED"
    r[_]["finding"]["uid"] = "CLOUDTRAIL-4"
}

test_cloudtrail_enabled_disable {
    r := violations with input as data.cloudtrail_enabled.disable
    count(r) == 1
    r[_]["finding"]["title"] = "CLOUD_TRAIL_ENABLED"
    r[_]["finding"]["uid"] = "CLOUDTRAIL-4"
}


