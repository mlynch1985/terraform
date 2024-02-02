package aws.aws_kms.kms_soft_deletion_enabled

test_kms_soft_deletion_enabled_valid {
	count(violations) == 0 with input as data.kms_soft_deletion_enabled.valid
}

test_kms_soft_deletion_enabled_ignore {
	count(violations) == 0 with input as data.kms_soft_deletion_enabled.ignore
}

test_kms_soft_deletion_enabled_invalid {
	r := violations with input as data.kms_soft_deletion_enabled.invalid
	count(r) == 1
	r[_].finding.title = "KMS_SOFT_DELETION_ENABLED"
	r[_].finding.uid = "KMS-5"
}

test_kms_soft_deletion_enabled_no_soft_delete {
	r := violations with input as data.kms_soft_deletion_enabled.no_soft_delete
	count(r) == 0
}
