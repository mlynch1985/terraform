package aws.amazon_s3.s3_bucket_versioning_enabled

test_s3_bucket_versioning_enabled_ignore {
    count(violations) == 0 with input as data.s3_bucket_versioning_enabled.ignore
}

test_s3_bucket_versioning_enabled_valid {
    count(violations) == 0 with input as data.s3_bucket_versioning_enabled.valid
}

test_s3_bucket_versioning_enabled_not_versioning_property {
    r = violations with input as data.s3_bucket_versioning_enabled.not_versioning_property
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_VERSIONING_ENABLED"
    r[_]["finding"]["uid"] = "S3-9"
}

test_s3_bucket_versioning_enabled_not_versioning_enabled {
    r = violations with input as data.s3_bucket_versioning_enabled.not_versioning_enabled
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_VERSIONING_ENABLED"
    r[_]["finding"]["uid"] = "S3-9"
}