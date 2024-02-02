package aws.iam.iam_user_permissions_boundary_attached

test_iam_user_permissions_boundary_attached_valid {
	count(violations) == 0 with input as data.iam_user_permissions_boundary_attached.valid
}

test_iam_user_permissions_boundary_attached_invalid_user {
	r := violations with input as data.iam_user_permissions_boundary_attached.invalid_user
	count(r) == 1
	r[_].finding.title = "IAM_USER_PERMISSIONS_BOUNDARY_ATTACHED"
	r[_].finding.uid = "IAM-7"
}
