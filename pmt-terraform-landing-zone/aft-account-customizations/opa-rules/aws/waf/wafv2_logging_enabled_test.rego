package aws.waf.wafv2_logging_enabled

test_wafv2_logging_enabled_valid {
    count(violations) == 0  with input as data.wafv2_logging_enabled.valid
}

test_wafv2_ignore {
    count(violations) == 0  with input as data.wafv2_logging_enabled.ignore
}

test_wafv2_no_logging_config {
    r := violations with input as data.wafv2_logging_enabled.invalid_no_logging_configuration
    count(r) == 1
    r[_]["finding"]["title"] = "WAFV2_LOGGING_ENABLED"
    r[_]["finding"]["uid"] = "WAF-1"
}

test_wafv2_no_waf_reference {
    r := violations with input as data.wafv2_logging_enabled.invalid_waf_reference
    count(r) == 1
    r[_]["finding"]["title"] = "WAFV2_LOGGING_ENABLED"
    r[_]["finding"]["uid"] = "WAF-1"
}

test_wafv2_invalid_logging_config {
    r := violations with input as data.wafv2_logging_enabled.invalid_logging_config
    count(r) == 1
    r[_]["finding"]["title"] = "WAFV2_LOGGING_ENABLED"
    r[_]["finding"]["uid"] = "WAF-1"
}
