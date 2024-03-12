# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
# Note that open-policy-agent/opa is licensed under the Apache License 2.0

package terraform.module

import data.utils

outputs[value] {
	value := input.planned_values.outputs
}

resources := {r |
	some path, value

	# Walk over the JSON tree and check if the node we are
	# currently on is a module (either root or child) resources
	# value.
	walk(input.planned_values, [path, value])

	# Look for resources in the current value based on path
	rs := module_resources(path, value)

	# Aggregate them into `resources`
	r := rs[_]
}

configurations := {c |
	some path, value

	# Walk over the JSON tree and check if the node we are
	# currently on is a module (either root or child) resources
	# value.
	walk(input.configuration, [path, value])

	# Look for resources in the current value based on path
	cs := module_resources(path, value)

	# Aggregate them into `resources`
	c := cs[_]
}

# Variant to match root_module resources
module_resources(path, value) = rs {
	# Expect something like:
	#
	#     {
	#     	"root_module": {
	#         	"resources": [...],
	#             ...
	#         }
	#         ...
	#     }
	#
	# Where the path is [..., "root_module", "resources"]

	reverse_index(path, 1) == "resources"
	reverse_index(path, 2) == "root_module"
	rs := value
}

# Variant to match child_modules resources
module_resources(path, value) = rs {
	# Expect something like:
	#
	#     {
	#     	...
	#         "child_modules": [
	#         	{
	#             	"resources": [...],
	#                 ...
	#             },
	#             ...
	#         ]
	#         ...
	#     }
	#
	# Where the path is [..., "child_modules", 0, "resources"]
	# Note that there will always be an index int between `child_modules`
	# and `resources`. We know that walk will only visit each one once,
	# so we shouldn not need to keep track of what the index is.

	reverse_index(path, 1) == "resources"
	reverse_index(path, 3) == "child_modules"
	rs := value
}

reverse_index(path, idx) = value {
	value := path[count(path) - idx]
}

ocsf_response(id, title, union) = response {
	ocsf_response := {
		"activity_name": "Generate",
		"activity_id": 2,
		"category_name": "Findings",
		"class_name": "Security Finding",
		"class_uid": 2001,
		"compliance": {"requirements": []},
		"confidence": "100%",
		"time": time.now_ns(),
		"finding": {
			"title": title,
			"uid": id,
		},
		"message": [],
		"metadata": {
			"product": {
				"name": "Terraform",
				"vendor_name": "Hashicorp",
			},
			"version": "1.0.0",
		},
		"resources": [],
		"severity": "HIGH",
		"severity_id": 4,
		"type_uid": 200101,
	}

	response := object.union(ocsf_response, union)
}

get_keys_with_prefix(obj, prefix) = keys {
	keys := [k |
		obj[k]
		startswith(k, prefix)
	]
}

# Check if resource evaluation should be skipped
skip_resource_evaluation(resource, rule_id, skip_rule_ids) {
	tag_prefix := "opa_skip"

	# Get resource tags
	tags := resource.values.tags

	# Get all tags with the prefix `tag_prefix`
	keys := get_keys_with_prefix(tags, tag_prefix)

	count(keys) > 0

	key = keys[_]

	# Split the tag value by `/` and check if the rule_id is in the list
	tvalues := split(tags[key], "/")

	val := tvalues[_]
	val == rule_id
} else {
	# Check if the rule_id is in the list of skip_rule_ids
	skip_rule_ids[_] = rule_id
}
