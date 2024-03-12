package aws.amazon_rds.rds_automatic_minor_version_upgrade_enabled

test_rds_automatic_minor_version_upgrade_enabled_valid {
	count(violations) == 0 with input as data.rds_automatic_minor_version_upgrade_enabled.valid
}

test_rds_automatic_minor_version_upgrade_enabled_ignore {
	count(violations) == 0 with input as data.rds_automatic_minor_version_upgrade_enabled.ignore
}

test_rds_automatic_minor_version_upgrade_enabled_no_key {
	count(violations) == 0 with input as data.rds_automatic_minor_version_upgrade_enabled.no_key
}

test_rds_automatic_minor_version_upgrade_enabled_invalid {
	r := violations with input as data.rds_automatic_minor_version_upgrade_enabled.invalid

	r[_].finding.title = "RDS_AUTOMATIC_MINOR_VERSION_UPGRADE_ENABLED"
	r[_].finding.uid = "RDS-6"
}
