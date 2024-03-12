# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "managed_config_rules" {
  source = "./modules/managed_config_rules"
  count  = local.ct_management_account_id != data.aws_caller_identity.current.account_id ? 1 : 0

  providers = {
    aws.region1 = aws.region1
    aws.region2 = aws.region2
    aws.region3 = aws.region3
  }

  rules = {
    "S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS" : {
      source_identifier = "S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS"
      description       = "Checks if the required public access block settings are configured from account level. The rule is only NON_COMPLIANT when the fields set below do not match the corresponding fields in the configuration item."
      input_parameters = jsonencode({
        IgnorePublicAcls      = "True"
        BlockPublicPolicy     = "True"
        BlockPublicAcls       = "True"
        RestrictPublicBuckets = "True"
      })
    },
    "EBS_ACCOUNT_LEVEL_VOLUME_ENCRYPTION_CHECK" : {
      source_identifier         = "ENCRYPTED_VOLUMES"
      description               = "Checks if attached Amazon EBS volumes are encrypted and optionally are encrypted with a specified KMS key. The rule is NON_COMPLIANT if attached EBS volumes are unencrypted or are encrypted with a KMS key not in the supplied parameters."
      compliance_resource_types = ["AWS::EC2::Volume"]
    },
    "EBS_ACCOUNT_LEVEL_VOLUME_ATTACHMENT_TO_EC2_CHECK" : {
      source_identifier         = "EC2_VOLUME_INUSE_CHECK"
      description               = "Checks if EBS volumes are attached to EC2 instances. Optionally checks if EBS volumes are marked for deletion when an instance is terminated."
      compliance_resource_types = ["AWS::EC2::Volume"]
      input_parameters = jsonencode({
        deleteOnTermination = "True"
      })
    },
    "EBS_OPTIMIZED_INSTANCE_ACCOUNT_LEVEL_CHECK" : {
      source_identifier         = "EBS_OPTIMIZED_INSTANCE"
      description               = "Checks if Amazon EBS optimization is enabled for your Amazon EC2 instances that can be Amazon EBS-optimized. The rule is NON_COMPLIANT if EBS optimization is not enabled for an Amazon EC2 instance that can be EBS-optimized."
      compliance_resource_types = ["AWS::EC2::Instance"]
    }
    "NO_UNRESTRICTED_ROUTE_TO_IGW" : {
      source_identifier = "NO_UNRESTRICTED_ROUTE_TO_IGW"
      description       = "A Config rule that checks if there are public routes in the route table to an Internet Gateway (IGW). The rule is NON_COMPLIANT if a route to an IGW has a destination CIDR block of '0.0.0.0/0' or '::/0' or if a destination CIDR block does not match the..."
    },
    "EBS_RESOURCES_PROTECTED_BY_BACKUP_PLAN" : {
      source_identifier = "EBS_RESOURCES_PROTECTED_BY_BACKUP_PLAN"
      description       = "Checks if Amazon Elastic Block Store (Amazon EBS) volumes are protected by a backup plan. The rule is NON_COMPLIANT if the Amazon EBS volume is not covered by a backup plan."
    },
    "INSTANCES_IN_VPC" : {
      source_identifier = "INSTANCES_IN_VPC"
      description       = "Checks if your EC2 instances belong to a virtual private cloud (VPC). Optionally, you can specify the VPC ID to associate with your instances."
    },
    "NETFW_LOGGING_ENABLED" : {
      source_identifier = "NETFW_LOGGING_ENABLED"
      description       = "Checks if AWS Network Firewall firewalls have logging enabled. The rule is NON_COMPLIANT if a logging type is not configured. You can specify which logging type you want the rule to check."
      input_parameters = jsonencode({
        logType = "both"
      })
    },
    "CW_LOGGROUP_RETENTION_PERIOD_CHECK" : {
      source_identifier = "CW_LOGGROUP_RETENTION_PERIOD_CHECK"
      description       = "Checks if Amazon CloudWatch LogGroup retention period is set to specific number of days. The rule is NON_COMPLIANT if the retention period for the log group is less than the MinRetentionTime parameter."
      input_parameters = jsonencode({
        MinRetentionTime = "365"
      })
    },
    "ATHENA_WORKGROUP_ENCRYPTED_AT_REST" : {
      source_identifier = "ATHENA_WORKGROUP_ENCRYPTED_AT_REST"
      description       = "Checks if an Amazon Athena workgroup is encrypted at rest. The rule is NON_COMPLIANT if encryption of data at rest is not enabled for an Athena workgroup."
    },
    "RDS_RESOURCES_PROTECTED_BY_BACKUP_PLAN" : {
      source_identifier = "RDS_RESOURCES_PROTECTED_BY_BACKUP_PLAN"
      description       = "Checks if Amazon Relational Database Service (Amazon RDS) instances are protected by a backup plan. The rule is NON_COMPLIANT if the Amazon RDS Database instance is not covered by a backup plan."
    },
    "EBS_IN_BACKUP_PLAN" : {
      source_identifier = "EBS_IN_BACKUP_PLAN"
      description       = "Check if Amazon Elastic Block Store (Amazon EBS) volumes are added in backup plans of AWS Backup. The rule is NON_COMPLIANT if Amazon EBS volumes are not included in backup plans."
    }
    "acm-certificate-expiration-check" : {
      source_identifier         = "ACM_CERTIFICATE_EXPIRATION_CHECK"
      description               = "Checks if ACM Certificates are marked for expiration within the specified number of days. Certs provided by ACM are automatically renewed except for the one's you import. The rule is NON_COMPLIANT if your certs are about to expire."
      compliance_resource_types = ["AWS::ACM::Certificate"]
      input_parameters = jsonencode({
        daysToExpiration = "90" // Specify the number of days before the rule flags the ACM Certificate as noncompliant. The actual value should reflect your organization's policies.
      })
    },
    "restricted-ssh" : {
      source_identifier         = "INCOMING_SSH_DISABLED"
      description               = "Checks if the incoming SSH traffic for the security groups is accessible. The rule is COMPLIANT when IP addresses of the incoming SSH traffic in the security groups are restricted (CIDR other than 0.0.0.0/0). This rule applies only to IPv4."
      compliance_resource_types = ["AWS::EC2::SecurityGroup"]
    },
    "ecs-fargate-latest-platform-version" : {
      source_identifier         = "ECS_FARGATE_LATEST_PLATFORM_VERSION"
      description               = "Checks if ECS Fargate services is set to the latest platform version. The rule is NON_COMPLIANT if PlatformVersion for the Fargate launch type is not set to LATEST, or if neither latestLinuxVersion nor latestWindowsVersion are provided as parameters."
      compliance_resource_types = ["AWS::ECS::Service"]
    },
    "ecs-task-definition-nonroot-user" : {
      source_identifier         = "ECS_TASK_DEFINITION_NONROOT_USER"
      description               = "Checks if ECSTaskDefinitions specify a user for Amazon Elastic Container Service (Amazon ECS) EC2 launch type containers to run on. The rule is NON_COMPLIANT if the ‘user’ parameter is not present or set to ‘root’."
      compliance_resource_types = ["AWS::ECS::TaskDefinition"]
    },
    "ecs-containers-nonprivileged" : {
      source_identifier         = "ECS_CONTAINERS_NONPRIVILEGED"
      description               = "Checks if the privileged parameter in the container definition of ECSTaskDefinitions is set to ‘true’. The rule is NON_COMPLIANT if the privileged parameter is ‘true’."
      compliance_resource_types = ["AWS::ECS::TaskDefinition"]
    },
    "ecs-containers-readonly-access" : {
      source_identifier         = "ECS_CONTAINERS_READONLY_ACCESS"
      description               = "Checks if Amazon ECS Containers only have read-only access to its root filesystems. The rule is NON_COMPLIANT if the readonlyRootFilesystem parameter in the container definition of ECSTaskDefinitions is set to ‘false’."
      compliance_resource_types = ["AWS::ECS::TaskDefinition"]
    },
    "ecr-private-image-scanning-enabled" : {
      source_identifier         = "ECR_PRIVATE_IMAGE_SCANNING_ENABLED"
      description               = "Checks if a private Amazon Elastic Container Registry (ECR) repository has image scanning enabled. The rule is NON_COMPLIANT if the private ECR repository's scan frequency is not on scan on push or continuous scan."
      compliance_resource_types = ["AWS::ECR::Repository"]
    },
    "ecs-no-environment-secrets" : {
      source_identifier         = "ECS_NO_ENVIRONMENT_SECRETS"
      description               = "Checks if secrets are passed as container environment variables. The rule is NON_COMPLIANT if 1 or more environment variable key matches a key listed in the 'secretKeys' parameter (excluding environmental variables from other locations such as Amazon S3)."
      compliance_resource_types = ["AWS::ECS::TaskDefinition"]
      input_parameters = jsonencode({
        secretKeys = "AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, ECS_ENGINE_AUTH_DATA" //Comma-separated list of key names to search for in the environment variables of container definitions within Task Definitions. Extra spaces will be removed.
      })
    },
    "secretsmanager-using-cmk" : {
      source_identifier         = "SECRETSMANAGER_USING_CMK"
      description               = "Checks if all secrets in AWS Secrets Manager are encrypted using the AWS managed key or a CMK that was created in AWS KMS. The rule is COMPLIANT if a secret is encrypted using a CMK and NON_COMPLIANT if a secret is encrypted using aws/secretsmanager."
      compliance_resource_types = ["AWS::SecretsManager::Secret"]
    },
    "secretsmanager-rotation-enabled-check" : {
      source_identifier         = "SECRETSMANAGER_ROTATION_ENABLED_CHECK"
      description               = "Checks if all secrets in AWS Secrets Manager are encrypted using the AWS managed key or a CMK that was created in AWS KMS. The rule is COMPLIANT if a secret is encrypted using a CMK and NON_COMPLIANT if a secret is encrypted using aws/secretsmanager."
      compliance_resource_types = ["AWS::SecretsManager::Secret"]
      input_parameters = jsonencode({
        maximumAllowedRotationFrequency = "90" // Maximum allowed rotation frequency of the secret in days.
      })
    },
    "SES_MALWARE_SCANNING_ENABLED" : {
      source_identifier         = "SES_MALWARE_SCANNING_ENABLED"
      description               = "Checks if malware and spam scanning on receiving messages is enabled for Amazon Simple Email Service (Amazon SES). The rule is NON_COMPLIANT if malware and spam scanning is not enabled."
      compliance_resource_types = ["AWS::SES::ReceiptRule"]
    },
    "IAM_GROUP_HAS_USERS_CHECK" : {
      source_identifier         = "IAM_GROUP_HAS_USERS_CHECK"
      description               = "Checks whether IAM groups have at least one IAM user."
      compliance_resource_types = ["AWS::IAM::Group"]
    },
    "SECURITYHUB_ENABLED" : {
      source_identifier = "SECURITYHUB_ENABLED"
      description       = "Checks whether SecurityHub is enabled."
    },
    "EC2_INSTANCE_NO_PUBLIC_IP" : {
      source_identifier = "EC2_INSTANCE_NO_PUBLIC_IP"
      description       = "Checks if EC2 instances have a public IP association. "
    }
  }
}
