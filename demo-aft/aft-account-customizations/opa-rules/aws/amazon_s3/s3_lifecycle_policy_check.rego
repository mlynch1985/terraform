# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    S3_LIFECYCLE_POLICY_CHECK
#
# Description:
# Checks if a lifecycle rule is configured for an Amazon Simple Storage Service (Amazon S3) bucket.
# The rule is NON_COMPLIANT if there is no active lifecycle configuration rules or the configuration does not match with the parameter values.
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

package aws.amazon_s3.s3_lifecycle_policy_check

import data.frameworks as frameworks
import data.terraform.module as terraform
import data.utils as utils
import future.keywords.in

resource_type := "aws_s3_bucket"

title := "S3_LIFECYCLE_POLICY_CHECK"

level := "HIGH"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

violations[response] {
	id := "S3-12"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	v_lifecycle_policies := object.get(data.variables, "enforce_s3_lifecycle_policy", [])
	count(v_lifecycle_policies) > 0

	expected_lifecycle_policy := get_enforced_lifecycle_policy(terraform.resources[j], v_lifecycle_policies)
	# Check lifecycle policy must be enforced to this bucket
	not has_valid_lifecycle_policy(terraform.resources[j], expected_lifecycle_policy)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource does not have lifecycle configuration rules or the configuration does not match with the parameter values. Please define a server_side_encryption_configuration block, set sse_algorithm to aws:kms, and provide a kms_master_key_id as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 3.1, 10.7, 10.5.3"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}

get_enforced_lifecycle_policy(tf_bucket, lifecycle_policies) = lifecycle_policy {
	regex.match(lifecycle_policies[x].bucket_names[_], tf_bucket.name)

	lifecycle_policy = lifecycle_policies[x]
} else = lifecycle_policy {
	c := object.get(lifecycle_policies[x], "bucket_names", [])
	count(c) == 0

	lifecycle_policy = lifecycle_policies[x]
}

has_valid_lifecycle_policy(tf_bucket, expected_lifecycle_policy) {
	# Check if the bucket has a lifecycle policy
	b_lifecycle_policies := tf_bucket.values.lifecycle_rule
	count(b_lifecycle_policies) > 0

	# Check if the lifecycle policy is valid
	has_valid_target_prefix(b_lifecycle_policies[x], expected_lifecycle_policy)
	has_valid_target_expiration_days(b_lifecycle_policies[x], expected_lifecycle_policy)
	has_valid_target_transition_days(b_lifecycle_policies[x].transition[y], expected_lifecycle_policy)
	has_valid_target_transition_storage_class(b_lifecycle_policies[x].transition[y], expected_lifecycle_policy)
}

has_valid_target_prefix(b_lifecycle_policy, expected_lifecycle_policy) {
	object.get(expected_lifecycle_policy, "target_prefix", false) == false
} else {
	b_lifecycle_policy.prefix == expected_lifecycle_policy.target_prefix
}

has_valid_target_expiration_days(b_lifecycle_policy, expected_lifecycle_policy) {
	object.get(expected_lifecycle_policy, "target_expiration_days", false) == false
} else {
	b_lifecycle_policy.expiration[_].days == expected_lifecycle_policy.target_expiration_days
}

has_valid_target_transition_days(b_lifecycle_policy_transition, expected_lifecycle_policy) {
	object.get(expected_lifecycle_policy, "target_transition_days", false) == false
} else {
	b_lifecycle_policy_transition.days == expected_lifecycle_policy.target_transition_days
}

has_valid_target_transition_storage_class(b_lifecycle_policy_transition, expected_lifecycle_policy) {
	object.get(expected_lifecycle_policy, "target_transition_storage_class", false) == false
} else {
	b_lifecycle_policy_transition.storage_class == expected_lifecycle_policy.target_transition_storage_class
}
