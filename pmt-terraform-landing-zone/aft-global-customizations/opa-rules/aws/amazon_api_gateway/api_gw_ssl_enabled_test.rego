package aws.amazon_api_gateway.api_gw_ssl_enabled

test_api_gw_ssl_enabled_valid {
	count(violations) == 0 with input as data.api_gw_ssl_enabled.valid
}

test_api_gw_ssl_enabled_ignore {
	count(violations) == 0 with input as data.api_gw_ssl_enabled.ignore
}

test_api_gw_ssl_enabled_invalid {
	r := violations with input as data.api_gw_ssl_enabled.invalid
	count(r) == 1
	r[_].finding.title = "API_GW_SSL_ENABLED"
	r[_].finding.uid = "AMAZON_API_GATEWAY-1"
}
