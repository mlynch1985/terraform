package aws.amazon_s3.s3_bucket_logging_enabled

test_s3_bucket_logging_enabled_ignore {
    count(violations) == 0 with input as data.s3_bucket_logging_enabled.ignore
}

test_s3_bucket_logging_enabled_valid {
    count(violations) == 0 with input as data.s3_bucket_logging_enabled.valid
}
test_s3_bucket_logging_enabled_log_resource {
    count(violations) == 0 with input as data.s3_bucket_logging_enabled.log_resource
}
test_s3_bucket_logging_enabled_inline_logging {
    count(violations) == 0 with input as data.s3_bucket_logging_enabled.inline_logging
}
test_s3_bucket_logging_enabled_all_types {
    r = violations with input as data.s3_bucket_logging_enabled.all_types
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_LOGGING_ENABLED"
    r[_]["finding"]["uid"] = "S3-10"
}

test_s3_bucket_logging_enabled_invalid {
    r = violations with input as data.s3_bucket_logging_enabled.invalid
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_LOGGING_ENABLED"
    r[_]["finding"]["uid"] = "S3-10"
}
