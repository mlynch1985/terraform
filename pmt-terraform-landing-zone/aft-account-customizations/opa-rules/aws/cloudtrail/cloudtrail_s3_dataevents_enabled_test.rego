package aws.cloudtrail.cloudtrail_s3_dataevents_enabled


test_cloudtrail_s3_dataevents_enabled_valid {
    count(violations) == 0  with input as data.cloudtrail_s3_dataevents_enabled.valid
}

test_cloudtrail_s3_dataevents_enabled_ignore {
    count(violations) == 0  with input as data.cloudtrail_s3_dataevents_enabled.ignore
}

test_cloudtrail_s3_dataevents_enabled_invalid {
    r := violations with input as data.cloudtrail_s3_dataevents_enabled.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "CLOUDTRAIL_S3_DATAEVENTS_ENABLED"
    r[_]["finding"]["uid"] = "CLOUDTRAIL-5"
}

test_cloudtrail_s3_dataevents_enabled_include_false {
    r := violations with input as data.cloudtrail_s3_dataevents_enabled.include_false
    count(r) == 1
    r[_]["finding"]["title"] = "CLOUDTRAIL_S3_DATAEVENTS_ENABLED"
    r[_]["finding"]["uid"] = "CLOUDTRAIL-5"
}

test_cloudtrail_s3_dataevents_enabled_key_null {
    r := violations with input as data.cloudtrail_s3_dataevents_enabled.key_null
    count(r) == 1
    r[_]["finding"]["title"] = "CLOUDTRAIL_S3_DATAEVENTS_ENABLED"
    r[_]["finding"]["uid"] = "CLOUDTRAIL-5"
}

test_cloudtrail_s3_dataevents_enabled_type_readonly {
    r := violations with input as data.cloudtrail_s3_dataevents_enabled.type_readonly
    count(r) == 1
    r[_]["finding"]["title"] = "CLOUDTRAIL_S3_DATAEVENTS_ENABLED"
    r[_]["finding"]["uid"] = "CLOUDTRAIL-5"
}


