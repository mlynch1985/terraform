package aws.lambda.lambda_function_public_access_prohibited

test_no_public_access_policy {
	r := violations with input as data.lambda_function_public_access_prohibited.valid
	count(r) == 0
}

test_no_public_access_policy_ignore {
	count(violations) == 0 with input as data.lambda_function_public_access_prohibited.ignore
}

test_public_policy {
	r := violations with input as data.lambda_function_public_access_prohibited.public
	count(r) == 6
	r[_].finding.title = "LAMBDA_FUNCTION_PUBLIC_ACCESS_PROHIBITED"
	r[_].finding.uid = "LAMBDA-2"
}
