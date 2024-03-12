package aws.amazon_s3.s3_bucket_level_public_access_prohibited

test_s3_bucket_level_public_access_prohibited_ignore {
    count(violations) == 0 with input as data.s3_bucket_level_public_access_prohibited.ignore
}

test_s3_bucket_level_public_access_prohibited_valid {
    count(violations) == 0 with input as data.s3_bucket_level_public_access_prohibited.valid
}

test_s3_bucket_level_public_access_prohibited_public_acl {
    r = violations with input as data.s3_bucket_level_public_access_prohibited.aws_s3_bucket
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_LEVEL_PUBLIC_ACCESS_PROHIBITED"
    r[_]["finding"]["uid"] = "S3-6"
}

test_s3_bucket_level_public_access_prohibited_aws_s3_bucket_public_access_block_valid {
    count(violations) == 0 with input as data.s3_bucket_level_public_access_prohibited.aws_s3_bucket_public_access_block
}

test_s3_bucket_level_public_access_prohibited_block_public_acls_invalid {
    r = violations with input as data.s3_bucket_level_public_access_prohibited.block_public_acls
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_LEVEL_PUBLIC_ACCESS_PROHIBITED"
    r[_]["finding"]["uid"] = "S3-6"
}

test_s3_bucket_level_public_access_prohibited_block_public_policy_and_restrict_public_buckets_invalid {
    r = violations with input as data.s3_bucket_level_public_access_prohibited.block_public_policy
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_LEVEL_PUBLIC_ACCESS_PROHIBITED"
    r[_]["finding"]["uid"] = "S3-6"
}

test_s3_bucket_level_public_access_prohibited_block_public_policy_invalid {
    r = violations with input as data.s3_bucket_level_public_access_prohibited.block_public_policy_and_restrict_public_buckets
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_LEVEL_PUBLIC_ACCESS_PROHIBITED"
    r[_]["finding"]["uid"] = "S3-6"
}

