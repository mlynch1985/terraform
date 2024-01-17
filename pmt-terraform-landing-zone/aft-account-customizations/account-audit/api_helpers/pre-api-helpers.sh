#!/bin/bash
# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

echo "Executing Pre-API Helpers"

# Drop out of Target Account session and into the AFT Execution role
export AWS_PROFILE=aft-management

# Query the AFT DynamoDB Table to retrieve a list of all AWS Accounts managed by AFT except for the CT Managment account, then save the output to a json file to be used by the Terraform stack
aws dynamodb scan --table-name aft-request-metadata --query "Items[?account_customizations_name.S!='account-root'].{id:id.S, name:account_name.S, email:email.S, account_customizations_name:account_customizations_name.S}" > $DEFAULT_PATH/$CUSTOMIZATION/terraform/account_list.json
