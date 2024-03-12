package aws.ssm.ssm_document_not_public

test_ssm_document_not_public {
	count(violations) == 0 with input as data.ssm_document_not_public.valid
}

test_ssm_document_not_public_ignore {
	count(violations) == 0 with input as data.ssm_document_not_public.ignore
}

test_ssm_document_not_public_invalid {
	r := violations with input as data.ssm_document_not_public.invalid
	count(r) == 1
	r[_].finding.title = "SSM_DOCUMENT_NOT_PUBLIC"
	r[_].finding.uid = "SSM-1"
}
