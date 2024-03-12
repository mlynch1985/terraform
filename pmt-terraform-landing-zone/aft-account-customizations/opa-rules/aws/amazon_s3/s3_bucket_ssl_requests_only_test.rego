package aws.amazon_s3.s3_bucket_ssl_requests_only

test_s3_bucket_ssl_requests_only {
    count(violations) == 0 with input as data.s3_bucket_ssl_requests_only.valid_resource_s3_policy
}