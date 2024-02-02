package aws.amazon_sns.sns_encrypted_kms

test_sns_encrypted_kms_valid {
	count(violations) == 0 with input as data.sns_encrypted_kms.valid
}

test_sns_encrypted_kms_ignore {
	count(violations) == 0 with input as data.sns_encrypted_kms.ignore
}

test_sns_encrypted_kms_invalid {
	r := violations with input as data.sns_encrypted_kms.invalid
	count(r) == 1
	r[_].finding.title = "SNS_ENCRYPTED_KMS"
	r[_].finding.uid = "SNS-1"
}

test_sns_encrypted_kms_key_null {
	r := violations with input as data.sns_encrypted_kms.key_null
	count(r) == 1
	r[_].finding.title = "SNS_ENCRYPTED_KMS"
	r[_].finding.uid = "SNS-1"
}
