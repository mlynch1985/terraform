package aws.amazon_s3.s3_account_level_public_access_block

test_s3_account_level_public_access_blocks_ignore {
    count(violations) == 0 with input as data.s3_account_level_public_access_block.ignore
}

test_s3_account_level_public_access_blocks_valid {
    count(violations) == 0 with input as data.s3_account_level_public_access_block.valid
}

test_s3_account_level_public_access_blocks_not_valid_block_public_acls {
    r = violations with input as data.s3_account_level_public_access_block.block_public_acls
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS"
    r[_]["finding"]["uid"] = "S3-1"
}

test_s3_account_level_public_access_blocks_not_valid_block_public_policy {
    r = violations with input as data.s3_account_level_public_access_block.block_public_policy
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS"
    r[_]["finding"]["uid"] = "S3-2"
}

test_s3_account_level_public_access_blocks_not_valid_ignore_public_acls {
    r = violations with input as data.s3_account_level_public_access_block.ignore_public_acls
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS"
    r[_]["finding"]["uid"] = "S3-3"
}

test_s3_account_level_public_access_blocks_not_valid_restrict_public_buckets {
    r = violations with input as data.s3_account_level_public_access_block.restrict_public_buckets
    count(r) == 1 
    r[_]["finding"]["title"] = "S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS"
    r[_]["finding"]["uid"] = "S3-4"
}

test_s3_account_level_public_access_blocks_not_valid {
    count(violations) == 4 with input as data.s3_account_level_public_access_block.all
}
