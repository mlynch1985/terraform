#!/bin/bash

# Reference:  https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external

# Parse the input variables into BASH Vars
eval "$(jq -r '@sh "ACCOUNT_NAME=\(.account_name)"')"

# Assume into our AFTExecution Role so we can query DynamoDB
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
  $(aws sts assume-role \
  --role-arn $AFT_EXEC_ROLE_ARN \
  --role-session-name AWSAFT-Session \
  --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
  --output text
  ))

# Now let's query our DynamoDB Table for the Network Account ID
aws dynamodb scan --table-name aft-request-metadata --query "Items[?account_name.S=='$ACCOUNT_NAME'].{id:id.S}[0]"
