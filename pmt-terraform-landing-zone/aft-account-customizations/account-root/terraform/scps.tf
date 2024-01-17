# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "scp_root" {
  source    = "./modules/scp"
  scp_name  = "scp_root"
  json_file = "${path.root}/scp_policies/root.json"
  ou_list   = [data.aws_organizations_organizational_units.root.id]
}
