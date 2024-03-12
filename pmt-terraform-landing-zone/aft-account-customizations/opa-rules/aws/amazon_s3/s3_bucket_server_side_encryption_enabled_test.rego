package aws.amazon_s3.s3_bucket_server_side_encryption_enabled

test_s3_bucket_server_side_encryption_enabled_ignore {
    count(violations) == 0 with input as data.s3_bucket_server_side_encryption_enabled.ignore
}

test_s3_bucket_server_side_encryption_enabled_valid {
    count(violations) == 0 with input as data.s3_bucket_server_side_encryption_enabled.valid
}
test_s3_bucket_server_side_encryption_enabled_valid_prop {
    count(violations) == 0 with input as data.s3_bucket_server_side_encryption_enabled.valid_prop
}
test_s3_bucket_server_side_encryption_enabled_valid_resource {
    count(violations) == 0 with input as data.s3_bucket_server_side_encryption_enabled.valid_resource
}
test_s3_bucket_server_side_encryption_enabled_bucket_with_no_sse {
    r = violations with input as data.s3_bucket_server_side_encryption_enabled.bucket_with_no_sse
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
    r[_]["finding"]["uid"] = "S3-7"
}

test_s3_bucket_server_side_encryption_enabled_invalid {
    r = violations with input as data.s3_bucket_server_side_encryption_enabled.invalid
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
    r[_]["finding"]["uid"] = "S3-7"
}
