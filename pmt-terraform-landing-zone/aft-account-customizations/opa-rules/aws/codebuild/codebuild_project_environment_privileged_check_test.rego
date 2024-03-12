package aws.codebuild.codebuild_project_environment_privileged_check

test_codebuild_project_environment_privileged_check_valid {
	count(violations) == 0 with input as data.codebuild_project_environment_privileged_check.valid
}

test_codebuild_project_environment_privileged_check_ignore {
	count(violations) == 0 with input as data.codebuild_project_environment_privileged_check.ignore
}

test_codebuild_project_environment_privileged_check_no_key {
	count(violations) == 0 with input as data.codebuild_project_environment_privileged_check.no_key
}

test_codebuild_project_environment_privileged_check_invalid {
	r := violations with input as data.codebuild_project_environment_privileged_check.invalid
	count(r) == 1
	r[_].finding.title = "CODEBUILD_PROJECT_ENVIRONMENT_PRIVILEGED_CHECK"
	r[_].finding.uid = "CODEBUILD-1"
}
