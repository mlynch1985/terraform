package aws.amazon_guardduty.guardduty_enabled_centralized

test_guardduty_enabled_centralized_valid {
	count(violations) == 0 with input as data.guardduty_enabled_centralized.valid
}

test_guardduty_enabled_centralized_ignore {
	count(violations) == 0 with input as data.guardduty_enabled_centralized.ignore
}

test_guardduty_enabled_centralized_invalid {
	r := violations with input as data.guardduty_enabled_centralized.invalid
	count(r) == 1
	r[_].finding.title = "GUARDDUTY_ENABLED_CENTRALIZED"
	r[_].finding.uid = "AMAZON_GUARDDUTY-1"
}

test_guardduty_enabled_centralized_disable {
	r := violations with input as data.guardduty_enabled_centralized.disable
	count(r) == 1
	r[_].finding.title = "GUARDDUTY_ENABLED_CENTRALIZED"
	r[_].finding.uid = "AMAZON_GUARDDUTY-1"
}
