package aws.elastic_load_balancing.elb_delete_protection_enabled

test_elb_delete_protection_enabled_ignore {
	count(violations) == 0 with input as data.elb_delete_protection_enabled.ignore
}

test_elb_delete_protection_enabled_valid {
	count(violations) == 0 with input as data.elb_delete_protection_enabled.valid
}

test_elb_delete_protection_enabled_no_property {
	r = violations with input as data.elb_delete_protection_enabled.no_property
	count(r) == 1
	r[_].finding.title = "ELB_DELETE_PROTECTION_ENABLED"
	r[_].finding.uid = "ELB-4"
}

test_elb_delete_protection_enabled_not_enabled {
	r = violations with input as data.elb_delete_protection_enabled.not_enabled
	count(r) == 1
	r[_].finding.title = "ELB_DELETE_PROTECTION_ENABLED"
	r[_].finding.uid = "ELB-4"
}
