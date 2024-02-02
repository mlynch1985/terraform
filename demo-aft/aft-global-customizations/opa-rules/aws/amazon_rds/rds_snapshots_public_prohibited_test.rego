package aws.rds.rds_snapshots_public_prohibited

test_rds_snapshots_public_prohibited_valid {
	count(violations) == 0 with input as data.rds_snapshots_public_prohibited.valid
}

test_rds_snapshots_public_prohibited_ignore {
	count(violations) == 0 with input as data.rds_snapshots_public_prohibited.ignore
}

test_rds_snapshots_public_prohibited_invalid {
	r := violations with input as data.rds_snapshots_public_prohibited.invalid
	count(r) == 1
	r[_].finding.title = "RDS_SNAPSHOTS_PUBLIC_PROHIBITED"
	r[_].finding.uid = "RDS-1"
}
