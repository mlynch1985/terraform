# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.

# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Rule Identifier:
#   ELBV2_ACM_CERTIFICATE_REQUIRED
#
# Description:
#    Checks if Application Load Balancers and Network Load Balancers have listeners that are configured to use
#    certificates from AWS Certificate Manager (ACM). This rule is NON_COMPLIANT if at least 1 load balancer
#    has at least 1 listener that is configured without a certificate from ACM or is configured with a
#    certificate different from an ACM certificate, such as an AWS IAM Server Cert.
#	 Parameter: List of ARNs that can be configured. Specified via config.json
#
# Resource Types:
#    aws_lb_listener
#
# Evaluates:
#    Terraform
#
# Rule Parameters:
#    NA
#

package aws.elastic_load_balancing_v2.elbv2_acm_certificate_required

import data.terraform.module as terraform
import data.utils as utils

# This is used for output and resource filtering (from mock data)
resource_type := "aws_lb_listener"

title := "ELBV2_ACM_CERTIFICATE_REQUIRED"

level := "HIGH"

cust_id := "Bofa-AxiaMed"

owner := "UNKNOWN"

# Step 5:  Fail the check if the ARN is for a certificate stored in IAM.
check_specific_acm_arn {
	confs := terraform.configurations[j]
	res := terraform.resources[y]
	res.type == "aws_lb_listener"

	#Checks the ARN specified in the terraform plan matches approved ARNs in config.json
	result := regex.match("arn:aws:iam:", confs.expressions.certificate_arn.constant_value)
	result == true
}

# Step 6: Function analyzes whether organization-approved ACM ARN(s) passed from config.json matches what the
# specific ACM ARN defined in the terraform plan.
check_specific_acm_arn {
	confs := terraform.configurations[j]
	res := terraform.resources[y]
	res.type == "aws_lb_listener"

	#Checks the ARN specified in the terraform plan matches approved ARNs in config.json
	not utils.array_contains(data.variables.elbv2_acm_arns, confs.expressions.certificate_arn.constant_value)
}

# Step 2: Function checks for an aws_acm_certificate association with aws_lb_listener is defined
# programmatically through terraform. This is an incremental rule used in conjunction with step 3.
check_acm_arns {
	confs := terraform.configurations[t]
	res := terraform.resources[x]
	res.type == "aws_acm_certificate"
	confs.type == "aws_lb_listener"

	#Checks that the "aws_acm_certificate.cert" address is referenced in the aws_lb_listener
	not utils.array_contains(confs.expressions.certificate_arn.references, res.address)
}

# Step 3: Function checks for an aws_iam_server_certificate association with aws_lb_listener is defined
# programmatically through terraform. This is an incremental rule used in conjunction with step 2c. There
# should NOT be an IAM server cert defined.
check_acm_arns {
	confs := terraform.configurations[t]
	res := terraform.resources[x]
	res.type == "aws_iam_server_certificate"
	confs.type == "aws_lb_listener"

	#Checks if a "aws_iam_server_certificate" address is referenced in the aws_lb_listener.
	utils.array_contains(confs.expressions.certificate_arn.references, res.address)
}

# Step 4: Function analyzes when aws_acm_certificate association with aws_lb_listener is defined with a
# specific ARN.
check_acm_arns {
	data.variables.elbv2_acm_arns != []
	confs := terraform.configurations[t]
	res := terraform.resources[x]
	confs.type == "aws_lb_listener"

	#Checks that a specific ARN is being passed in
	utils.has_key(confs.expressions.certificate_arn, "constant_value")
	check_specific_acm_arn
}

# Step 1: This function calls other functions to analyze the aws_lb_listener for ACM associations created
# programmatically through terraform or via providing a specific ARN. Certificates should NOT be defined via
# AWS IAM server certificates.
check_cert {
	check_acm_arns
}

violations[response] {
	id := "ELASTIC_LOAD_BALANCING_V2-4"

	terraform.resources[j].type == resource_type

	# Check if the rule should be ignored for this resource
	not terraform.skip_resource_evaluation(terraform.resources[j], id, data.ignore_rules)

	check_cert

	response := terraform.ocsf_response(id, title, {
		"message": {
			"RESOURCE": terraform.resources[j].address,
			"OPA ID": id,
			"CONFIG RULE": title,
			"CUSTOMER ID": cust_id,
			"OWNER": owner,
			"severity": level,
			"Description": sprintf(
				"Resource (%s) does not have listeners configured to use certificates from AWS Certificate Manager (ACM). This rule is NON_COMPLIANT if at least 1 load balancer has 1 listener configured without a certificate from ACM or is optionally configured with a certificate different from what is specified in config.json: %s . Please refer to https://registry.terraform.io/providers/hashicorp/aws/2.36.0/docs/resources/lb_listener",
				[terraform.resources[j].address, data.variables.elbv2_acm_arns],
			),
		},
		"compliance": {"requirements": ["PCI DSS 3.2.1, Control ID(s): 4.1"]},
		"resources": {
			"cloud_partition": "aws",
			"group_name": terraform.resources[j].type,
			"uid": terraform.resources[j].address,
		},
	})
}
