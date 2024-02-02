package aws.elastic_load_balancing.alb_waf_enabled

test_alb_waf_enabled_valid {
	count(violations) == 0 with input as data.alb_waf_enabled.valid
}

test_alb_waf_enabled_valid_arn_provided {
	count(violations) == 0 with input as data.alb_waf_enabled.valid_arn_provided
}

test_alb_waf_enabled_valid_arn_provided2 {
	count(violations) == 0 with input as data.alb_waf_enabled.valid_arn_provided2
}

test_alb_waf_enabled_valid_classic {
	count(violations) == 0 with input as data.alb_waf_enabled.valid_classic
}

test_alb_waf_enabled_valid_classic_arn_provided {
	count(violations) == 0 with input as data.alb_waf_enabled.valid_classic_arn_provided
}

test_alb_waf_enabled_valid_classic_arn_provided2 {
	count(violations) == 0 with input as data.alb_waf_enabled.valid_classic_arn_provided2
}

test_alb_waf_enabled_invalid_arn_provided {
	r := violations with input as data.alb_waf_enabled.invalid_arn_provided
	count(r) == 1
	r[_].finding.title = "ALB_WAF_ENABLED"
	r[_].finding.uid = "ELB-3"
}

test_alb_waf_enabled_invalid_classic_arn_provided {
	r := violations with input as data.alb_waf_enabled.invalid_classic_arn_provided
	count(r) == 1
	r[_].finding.title = "ALB_WAF_ENABLED"
	r[_].finding.uid = "ELB-3"
}

test_alb_waf_enabled_invalid_classic_no_reference {
	r := violations with input as data.alb_waf_enabled.invalid_classic_no_reference
	count(r) == 1
	r[_].finding.title = "ALB_WAF_ENABLED"
	r[_].finding.uid = "ELB-3"
}

test_alb_waf_enabled_invalid_no_reference {
	r := violations with input as data.alb_waf_enabled.invalid_no_reference
	count(r) == 1
	r[_].finding.title = "ALB_WAF_ENABLED"
	r[_].finding.uid = "ELB-3"
}

test_alb_waf_enabled_invalid_no_waf_association {
	r := violations with input as data.alb_waf_enabled.invalid_no_waf_association
	count(r) == 1
	r[_].finding.title = "ALB_WAF_ENABLED"
	r[_].finding.uid = "ELB-3"
}
