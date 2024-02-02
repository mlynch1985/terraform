# This AWS Content is provided subject to the terms of the AWS Customer Agreement 
# available at http://aws.amazon.com/agreement or other written agreement between 
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both. 

# Rule Identifier:
#    EFS_ACCESS_POINT_ENFORCE_USER_IDENTITY
#
# Description:
#    Checks if Amazon Elastic File System (Amazon EFS) access points are configured to enforce a user identity. 
#    The rule is NON_COMPLIANT if 'PosixUser' is not defined or if parameters are provided and there is no match in the corresponding parameter. 
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
package aws.amazon_efs.efs_access_point_enforce_user_identity

import data.terraform.module as terraform
import data.utils as utils

resource_type := "aws_efs_access_point"

level := "HIGH"

cust_id := "Bofa-axiamed"

owner := "UNKNOWN"

title := "EFS_ACCESS_POINT_ENFORCE_USER_IDENTITY"

is_posix(values) {
	object.get(values, "posix_user", []) == []
} else {
	p := {v |
		v := values.posix_user[_].uid
	}
	count(p) == 0
}

violations[response] {
	id := "EFS-2"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	is_posix(terraform.resources[j].values)

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"SEVERITY": level,
			"DESCRIPTION": "Resource should not configure posix_user uid. Please provide a posix_user as detailed in this documentation https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point#posix_user",
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 7.1.1, 7.2.1, 7.2.2"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
