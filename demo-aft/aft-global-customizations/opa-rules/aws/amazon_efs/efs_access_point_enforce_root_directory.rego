# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#    EFS_ACCESS_POINT_ENFORCE_ROOT_DIRECTORY
#
# Description:
#    Checks if Amazon Elastic File System (Amazon EFS) access points are configured to enforce a root directory.
#    The rule is NON_COMPLIANT if the value of 'Path' is set to '/' (default root directory of the file system).
#
# Resource Types:
#    aws_efs_access_point
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#
package aws.amazon_efs.efs_access_point_enforce_root_directory

import data.terraform.module as terraform
import data.utils as utils

import future.keywords

resource_type := "aws_efs_access_point"

title := "EFS_ACCESS_POINT_ENFORCE_ROOT_DIRECTORY"

level := "HIGH"

cust_id := "TBD"

owner := "TBD"

is_root_directory_path(values) if {
	object.get(values, "root_directory", []) == []
} else if {
	p := {v |
		v := object.get(values.root_directory[_], "path", "") in ["", "/"]
	}
	p[true]
}

violations contains response if {
	id := "EFS-1"

	terraform.resources[j].type == "aws_efs_access_point"

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	is_root_directory_path(terraform.resources[j].values)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource should not configure root_directory path to '/'. Please provide a root_directory as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point#root_directory",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1.1, 7.2.1, 7.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
