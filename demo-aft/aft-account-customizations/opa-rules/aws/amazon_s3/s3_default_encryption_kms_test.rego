package aws.amazon_s3.s3_default_encryption_kms

test_s3_default_encryption_kms_ignore {
    count(violations) == 0 with input as data.s3_default_encryption_kms.ignore
}

test_s3_default_encryption_kms_valid {
    count(violations) == 0 with input as data.s3_default_encryption_kms.valid   
}

test_s3_default_encryption_kms_encryption_not_present {
    r = violations with input as data.s3_default_encryption_kms.encryption_not_present
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_DEFAULT_ENCRYPTION_KMS"
    r[_]["finding"]["uid"] = "S3-3"
}

test_s3_default_encryption_kms_encryption_not_valid_encryption {
    r = violations with input as data.s3_default_encryption_kms.not_valid_encryption
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_DEFAULT_ENCRYPTION_KMS"
    r[_]["finding"]["uid"] = "S3-3"
}