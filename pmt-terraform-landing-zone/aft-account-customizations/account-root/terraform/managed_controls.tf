# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "managed_controls" {
  source = "./modules/managed_controls"

  controls = [
    {
      control_names = [
        "AWS-GR_S3_BUCKET_PUBLIC_READ_PROHIBITED", //start of S3 service
        "AWS-GR_S3_BUCKET_PUBLIC_WRITE_PROHIBITED",
        "AWS-GR_AUDIT_BUCKET_LOGGING_ENABLED",
        "AWS-GR_AUDIT_BUCKET_RETENTION_POLICY",

        "AWS-GR_RESTRICT_ROOT_USER_ACCESS_KEYS", //start of IAM service
        "AWS-GR_RESTRICT_ROOT_USER",
        "AWS-GR_ROOT_ACCOUNT_MFA_ENABLED",
        "AWS-GR_IAM_USER_MFA_ENABLED",
        "AWS-GR_MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS"

      ],
      organizational_unit_ids = [
        data.aws_organizations_organizational_units.deployments.id,
        data.aws_organizations_organizational_units.infrastructure.id,
        data.aws_organizations_organizational_units.policy-staging.id,
        data.aws_organizations_organizational_units.sandbox.id,
        data.aws_organizations_organizational_units.security.id,
        data.aws_organizations_organizational_units.suspended.id,
        data.aws_organizations_organizational_units.workloads.id
      ]
    }
  ]
}
