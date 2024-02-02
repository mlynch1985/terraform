package aws.amazon_ecr.ecr_private_image_scanning_enabled

test_ecr_private_image_scanning_enabled_ignore {
    count(violations) == 0 with input as data.ecr_private_image_scanning_enabled.ignore
}

test_ecr_private_image_scanning_enabled_valid {
    count(violations) == 0 with input as data.ecr_private_image_scanning_enabled.valid   
}

test_ecr_private_image_scanning_enabled_not_present {
    r = violations with input as data.ecr_private_image_scanning_enabled.not_present
    count(r) == 1 
    r[_]["finding"]["title"] = "ECR_PRIVATE_IMAGE_SCANNING_ENABLED"
    r[_]["finding"]["uid"] = "ECR-1"
}

test_ecr_private_image_scanning_enabled_scan_disabled {
    r = violations with input as data.ecr_private_image_scanning_enabled.scan_disabled
    count(r) == 1 
    r[_]["finding"]["title"] = "ECR_PRIVATE_IMAGE_SCANNING_ENABLED"
    r[_]["finding"]["uid"] = "ECR-1"
}