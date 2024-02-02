package aws.amazon_s3.s3_bucket_replication_enabled

test_s3_bucket_replication_enabled_ignore {
    count(violations) == 0 with input as data.s3_account_level_public_access_block.ignore
}

test_s3_bucket_replication_enabled_valid_with_replication_resorce {
   count(violations) == 0 with input as data.s3_bucket_replication_enabled.valid_with_replication_resorce
   
}

test_s3_bucket_replication_enabled_valid_with_rep_as_attribute {
   count(violations) == 0 with input as data.s3_bucket_replication_enabled.valid_with_rep_as_attribute
}

test_s3_bucket_replication_enabled_rep_as_attribute_extra_bucket {
   r = violations with input as data.s3_bucket_replication_enabled.rep_as_attribute_extra_bucket
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_REPLICATION_ENABLED"
    r[_]["finding"]["uid"] = "S3-2"
}
test_s3_bucket_replication_enabled_invalid {
   r = violations with input as data.s3_bucket_replication_enabled.invalid
    count(r) == 2
    r[_]["finding"]["title"] = "S3_BUCKET_REPLICATION_ENABLED"
    r[_]["finding"]["uid"] = "S3-2"
}
test_s3_bucket_replication_enabled_invalid_with_replication_resorce {
   r = violations with input as data.s3_bucket_replication_enabled.invalid_with_replication_resorce
    count(r) == 1
    r[_]["finding"]["title"] = "S3_BUCKET_REPLICATION_ENABLED"
    r[_]["finding"]["uid"] = "S3-2"
}
