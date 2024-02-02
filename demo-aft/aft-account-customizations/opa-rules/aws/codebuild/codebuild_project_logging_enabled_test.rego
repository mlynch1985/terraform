package aws.codebuild.codebuild_project_logging_enabled

test_codebuild_project_logging_enabled_valid {
	count(violations) == 0 with input as data.codebuild_project_logging_enabled.valid
}

test_codebuild_project_logging_enabled_ignore {
	count(violations) == 0 with input as data.codebuild_project_logging_enabled.ignore
}

test_codebuild_project_logging_enabled_no_key {
	count(violations) == 0 with input as data.codebuild_project_logging_enabled.no_key
}

test_codebuild_project_logging_enabled_invalid {
	r := violations with input as data.codebuild_project_logging_enabled.invalid

	r[_].finding.title = "CODEBUILD_PROJECT_LOGGING_ENABLED"
	r[_].finding.uid = "CODEBUILD-2"
}

test_codebuild_project_logging_enabled_lcfg_empty {
	r := violations with input as data.codebuild_project_logging_enabled.lcfg_empty

	r[_].finding.title = "CODEBUILD_PROJECT_LOGGING_ENABLED"
	r[_].finding.uid = "CODEBUILD-2"
}
