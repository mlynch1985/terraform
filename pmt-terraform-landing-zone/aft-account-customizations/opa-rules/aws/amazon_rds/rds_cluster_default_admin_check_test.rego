package aws.rds.rds_cluster_default_admin_check

test_rds_cluster_default_admin_check_valid {
	count(violations) == 0 with input as data.rds_cluster_default_admin_check.valid
}

test_rds_cluster_default_admin_check_ignore {
	count(violations) == 0 with input as data.rds_cluster_default_admin_check.ignore
}

test_rds_cluster_default_admin_check_invalid {
	r := violations with input as data.rds_cluster_default_admin_check.invalid
	count(r) == 2
	r[_].finding.title = "RDS_CLUSTER_DEFAULT_ADMIN_CHECK"
	r[_].finding.uid = "RDS-5"
}
