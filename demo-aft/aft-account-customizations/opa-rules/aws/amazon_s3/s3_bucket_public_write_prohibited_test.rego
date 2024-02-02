package aws.amazon_s3.s3_bucket_public_write_prohibited

test_s3_bucket_public_write_prohibited_valid {
    count(violations) == 0 with input as data.s3_bucket_public_write_prohibited_mock.valid
}

test_s3_bucket_public_write_prohibited_ignore {
    count(violations) == 0 with input as data.s3_bucket_public_write_prohibited_mock.ignore
}

test_s3_bucket_public_write_prohibited_invalid_acl_public_res {
    r = violations with input as data.s3_bucket_public_write_prohibited_mock.invalid_acl_public_res
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
    r[_]["finding"]["uid"] = "S3-8"
}

test_s3_bucket_public_write_prohibited_invalid_acl_res {
    r = violations with input as data.s3_bucket_public_write_prohibited_mock.invalid_acl_res
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
    r[_]["finding"]["uid"] = "S3-8"
}

test_s3_bucket_public_write_prohibited_invalid_both {
    r = violations with input as data.s3_bucket_public_write_prohibited_mock.invalid_both
    count(r) == 2
    r[_]["finding"]["title"] = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
    r[_]["finding"]["uid"] = "S3-8"
}
