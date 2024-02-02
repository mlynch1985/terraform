package aws.waf.waf_regional_webacl_not_empty

test_waf_regional_webacl_not_empty_test_valid {
    count(violations) == 0  with input as data.waf_regional_webacl_not_empty.valid
}

test_waf_regional_webacl_not_empty_test_ignore {
    count(violations) == 0  with input as data.waf_regional_webacl_not_empty.ignore
}

test_waf_regional_webacl_not_empty_test_invalid {
    r := violations with input as data.waf_regional_webacl_not_empty.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "WAF_REGIONAL_WEBACL_NOT_EMPTY"
    r[_]["finding"]["uid"] = "WAF-3"
}