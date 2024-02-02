package aws.amazon_api_gateway.api_gw_associated_with_waf

test_api_gw_associated_with_waf_valid {
	count(violations) == 0 with input as data.api_gw_associated_with_waf.valid
}

test_api_gw_associated_with_waf_valid_arn_provided {
	count(violations) == 0 with input as data.api_gw_associated_with_waf.valid_arn_provided
}

test_api_gw_associated_with_waf_valid_arn_provided2 {
	count(violations) == 0 with input as data.api_gw_associated_with_waf.valid_arn_provided2
}

test_api_gw_associated_with_waf_invalid_arn_provided {
	r := violations with input as data.api_gw_associated_with_waf.invalid_arn_provided
	count(r) == 1
	r[_].finding.title = "API_GW_ASSOCIATED_WITH_WAF"
	r[_].finding.uid = "AMAZON_API_GATEWAY-2"
}

test_api_gw_associated_with_waf_invalid_no_reference {
	r := violations with input as data.api_gw_associated_with_waf.invalid_no_reference
	count(r) == 1
	r[_].finding.title = "API_GW_ASSOCIATED_WITH_WAF"
	r[_].finding.uid = "AMAZON_API_GATEWAY-2"
}

test_api_gw_associated_with_waf_invalid_no_waf_association {
	r := violations with input as data.api_gw_associated_with_waf.invalid_no_waf_association
	count(r) == 1
}
