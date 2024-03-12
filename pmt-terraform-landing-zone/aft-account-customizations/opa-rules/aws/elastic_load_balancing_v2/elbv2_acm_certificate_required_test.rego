package aws.elastic_load_balancing_v2.elbv2_acm_certificate_required

test_elbv2_acm_certificate_required_valid {
	count(violations) == 0 with input as data.elbv2_acm_certificate_required.valid
}

test_elbv2_acm_certificate_required_valid_arn_provided {
	count(violations) == 0 with input as data.elbv2_acm_certificate_required.valid_arn_provided
}

test_elbv2_acm_certificate_required_valid_arn_provided2 {
	count(violations) == 0 with input as data.elbv2_acm_certificate_required.valid_arn_provided2
}

test_elbv2_acm_certificate_required_ignore {
	count(violations) == 0 with input as data.elbv2_acm_certificate_required.ignore
}

test_elbv2_acm_certificate_required_invalid_iam_cert {
	r := violations with input as data.elbv2_acm_certificate_required.invalid_iam_cert
	count(r) == 1
	r[_].finding.title = "ELBV2_ACM_CERTIFICATE_REQUIRED"
	r[_].finding.uid = "ELASTIC_LOAD_BALANCING_V2-4"
}

test_elbv2_acm_certificate_required_invalid {
	r := violations with input as data.elbv2_acm_certificate_required.invalid
	count(r) == 1
	r[_].finding.title = "ELBV2_ACM_CERTIFICATE_REQUIRED"
	r[_].finding.uid = "ELASTIC_LOAD_BALANCING_V2-4"
}

test_elbv2_acm_certificate_required_invalid_acm_arn {
	r := violations with input as data.elbv2_acm_certificate_required.invalid_acm_arn
	count(r) == 1
	r[_].finding.title = "ELBV2_ACM_CERTIFICATE_REQUIRED"
	r[_].finding.uid = "ELASTIC_LOAD_BALANCING_V2-4"
}

test_elbv2_acm_certificate_required_invalid_iam_arn_provided {
	r := violations with input as data.elbv2_acm_certificate_required.invalid_iam_arn_provided
	count(r) == 1
	r[_].finding.title = "ELBV2_ACM_CERTIFICATE_REQUIRED"
	r[_].finding.uid = "ELASTIC_LOAD_BALANCING_V2-4"
}
