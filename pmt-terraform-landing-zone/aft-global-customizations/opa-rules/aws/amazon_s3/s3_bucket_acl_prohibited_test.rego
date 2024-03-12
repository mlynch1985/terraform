package aws.amazon_s3.s3_bucket_acl_prohibited

test_s3_bucket_acl_prohibited_ignore {
    count(violations) == 0 with input as data.s3_bucket_acl_prohibited.ignore
}

test_s3_bucket_acl_prohibited_valid {
    count(violations) == 0 with input as data.s3_bucket_acl_prohibited.valid
}
test_s3_bucket_acl_prohibited_invalid {
    r = violations with input as data.s3_bucket_acl_prohibited.invalid
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_BUCKET_ACL_PROHIBITED"
    r[_]["finding"]["uid"] = "S3-5"
}
