#!/bin/bash
cd ~/aft-account-customizations/account-log-archive/terraform
terraform plan -input=false -refresh -no-color -out=tfplan.bin > /dev/null
terraform show -json tfplan.bin > tfplan.json
#test the OPA rule with terraform plan output
opa eval --format=pretty -i tfplan.json \
-d ../../policy-as-code-for-all-accounts/rego/aws/amazon_rds/rds_db_cluster_iam_authentication_enabled.rego \
-d ../../policy-as-code-for-all-accounts/rego/utils.rego \
-d ../../policy-as-code-for-all-accounts/rego/terraform_module.rego \
-d ../../policy-as-code-for-all-accounts/rego/config.json "data.aws" | jq -r '.. | .message? | select(. != null)'