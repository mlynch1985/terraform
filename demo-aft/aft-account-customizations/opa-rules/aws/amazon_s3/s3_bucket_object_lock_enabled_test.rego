package aws.amazon_s3.s3_bucket_object_lock_enabled

test_s3_bucket_object_lock_enabled_ignore {
    count(violations) == 0 with input as data.s3_bucket_object_lock_enabled.ignore
}

test_s3_s3_bucket_object_lock_enabled_valid {
    count(violations) == 0 with input as data.s3_bucket_object_lock_enabled.valid
}

test_s3_bucket_object_lock_no_object_lock_property {
    r = violations with input as data.s3_bucket_object_lock_enabled.no_object_lock_property
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_OBJECT_LOCK_ENABLED"
    r[_]["finding"]["uid"] = "S3-15"
}

test_s3_s3_bucket_object_lock_enabled_object_lock_not_enabled {
    r = violations with input as data.s3_bucket_object_lock_enabled.object_lock_not_enabled
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_OBJECT_LOCK_ENABLED"
    r[_]["finding"]["uid"] = "S3-15"
}