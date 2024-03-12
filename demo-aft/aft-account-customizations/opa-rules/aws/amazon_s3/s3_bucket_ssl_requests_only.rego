# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    S3_BUCKET_SSL_REQUESTS_ONLY
#
# Description:
# Checks if Amazon S3 buckets have policies that require requests to use Secure Socket Layer (SSL).
# The rule is COMPLIANT if buckets explicitly deny access to HTTP requests. The rule is NON_COMPLIANT if bucket policies allow HTTP requests.
#
# Resource Types:
#    aws_s3_bucket
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.amazon_s3.s3_bucket_ssl_requests_only

import data.frameworks as frameworks
import data.terraform.module as terraform
import data.utils as utils
import future.keywords.in

resource_type := "aws_s3_bucket"

title := "S3_BUCKET_SSL_REQUESTS_ONLY"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

violations[response] {
	id := "S3-4"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	s3_policy := get_s3_bucket_poliy(terraform.resources[j])

	not has_valid_s3_policy(terraform.resources[j], s3_policy)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource should have attached a resource policy that explicitly denies access to HTTP requests. Please attach a resource policy as detailed here https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 2.2, 4.1, 8.2.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

get_s3_bucket_poliy(s3_resource) := b_policy {
	b_policy := json.unmarshal(lower(object.get(s3_resource.values, "policy", {})))
	count(b_policy) > 0
} else = b_policy {
	b_policy := get_s3_bucket_poliy_resource(s3_resource)
}

get_s3_bucket_poliy_resource(s3_resource) = b_policy {
	rep_res := {b |
		b := terraform.configurations[x]
		terraform.configurations[x].type in ["aws_s3_bucket_policy"]
	}
	count(rep_res) > 0

	s3_resource.address in rep_res[w].expressions.bucket.references
	terraform.resources[a].address in rep_res[w].expressions.policy.references
	b_policy := terraform.resources[a].values
}

has_valid_s3_policy(s3_resource, s3_policy) {
	count(s3_policy) == 0
}

has_valid_s3_policy(s3_resource, s3_policy) {
	utils.has_key(s3_policy, "source_json")
	statement := object.get(s3_policy, "source_json", [])
	statement != null

	action := object.get(statement[_], "action", [])
	effect := object.get(statement[_], "effect", null)
	conditions := object.get(statement[_], "condition", [])
	principals := object.get(statement[_], "principal", [])

	validate_s3_lifecycle_policy(s3_resource, action, effect, conditions, principals)
} else {
	utils.has_key(s3_policy, "source_json")

	statement := object.get(s3_policy, "statement", [])

	action := object.get(statement[_], "actions", [])
	effect := object.get(statement[_], "effect", null)
	conditions := object.get(statement[_], "condition", [])
	principals := object.get(statement[_], "principals", [])

	validate_s3_lifecycle_policy(s3_resource, action, effect, conditions, principals)
} else {
	statement := object.get(s3_policy, "statement", [])
	utils.has_key(statement[_], "action")

	action := object.get(statement[_], "action", [])
	effect := object.get(statement[_], "effect", null)
	conditions := object.get(statement[_], "condition", [])
	principals := object.get(statement[_], "principal", [])

	validate_s3_lifecycle_policy(s3_resource, action, effect, conditions, principals)
}

validate_s3_lifecycle_policy(s3_resource, action, effect, conditions, principals) {
	effect == "deny"
	validate_policy_action(action)
	validate_policy_principals(principals)
	validate_secure_trasport(conditions)
}

validate_policy_action(action) {
	glob.match("s3:*", [":"], action[_])
}

validate_policy_action(action) {
	glob.match("s3:*", [":"], action)
}

validate_policy_principals(principals) {
	"*" == principals
}

validate_policy_principals(principals) {
	"*" in principals
}

validate_secure_trasport(conditions) {
	securetransport := object.get(conditions[_], "aws:securetransport", null)
	securetransport == "false"
}

validate_secure_trasport(conditions) {
	var := object.get(conditions[_], "variable", null)
	val := object.get(conditions[_], "values", null)
	var == "aws:SecureTransport"
	"false" in val
}
