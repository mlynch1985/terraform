package aws.elastic_load_balancing.elb_tls_https_listeners_only

test_elb_tls_https_listeners_only_valid {
	count(violations) == 0 with input as data.elb_tls_https_listeners_only.valid
}

test_elb_tls_https_listeners_only_ssl_valid {
	count(violations) == 0 with input as data.elb_tls_https_listeners_only.ssl_valid
}

test_elb_tls_https_listeners_only_ignore {
	count(violations) == 0 with input as data.elb_tls_https_listeners_only.ignore
}

test_elb_tls_https_listeners_only_invalid {
	r := violations with input as data.elb_tls_https_listeners_only.invalid
	count(r) == 1
	r[_].finding.title = "ELB_TLS_HTTPS_LISTENERS_ONLY"
	r[_].finding.uid = "ELB-2"
}
