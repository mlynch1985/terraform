# # © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# # This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# # http://aws.amazon.com/agreement or other written agreement between Customer and either
# # Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.


# Lookup Network Account ID so we can pass it to Workload Accounts needed to establish TGW Connections
data "external" "network_account_id" {
  program = ["bash", "./get_account_id.sh"]
  query   = { account_name = "Network" }
}

locals {
  tgw_asn = "64513" # Used to identify the correct TGW in each Workload Account for TGW Attachments
}
