# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# CloudWatch Alarm for root user login
module "root_user_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  metric_name       = "RootUserEventCount"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers if a root user uses the account."
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{ ($.userIdentity.type = \"Root\") && ($.userIdentity.invokedBy NOT EXISTS) && ($.eventType != \"AwsServiceEvent\") }"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}

# CloudWatch Alarm for Changes to CloudTrail
module "cloudtrail_change_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  metric_name       = "CloudTrailEventCount"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers when changes are made to CloudTrail configuration."
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{ ($.eventName = CreateTrail) || ($.eventName = UpdateTrail) || ($.eventName = DeleteTrail) || ($.eventName = StartLogging) || ($.eventName = StopLogging) }"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}

# A CloudWatch Alarm that triggers when changes are made to an Internet Gateway in a VPC.
module "gw_change_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  period            = 300
  metric_name       = "GatewayEventCount"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers when changes are made to an Internet Gateway in a VPC."
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{ ($.eventName = CreateCustomerGateway) || ($.eventName = DeleteCustomerGateway) || ($.eventName = AttachInternetGateway) || ($.eventName = CreateInternetGateway) || ($.eventName = DeleteInternetGateway) || ($.eventName = DetachInternetGateway) }"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}

# A CloudWatch Alarm that triggers when changes are made to Network ACLs.
module "nacl_change_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  period            = 300
  metric_name       = "NetworkAclEventCount"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers when changes are made to Network ACLs."
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}

# A CloudWatch Alarm that triggers when changes are made to a VPC's Route Table.
module "vpc_rt_change_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  period            = 300
  metric_name       = "VpcRouteTableEventCount"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers when changes are made to a VPC's Route Table."
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{ ($.eventName = AssociateRouteTable) || ($.eventName = CreateRoute) || ($.eventName = CreateRouteTable) || ($.eventName = DeleteRoute) || ($.eventName = DeleteRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName = ReplaceRouteTableAssociation) || ($.eventName = DisassociateRouteTable) }"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}

# A CloudWatch Alarm that triggers when changes are made to a VPC.
module "vpc_change_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  period            = 300
  metric_name       = "VpcEventCount"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers when changes are made to a VPC."
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{ ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) }"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}

# A CloudWatch Alarm that triggers when changes are made to Security Groups.
module "security_group_change_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  period            = 300
  metric_name       = "SecurityGroupEventCount"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers when changes are made to Security Groups."
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup) }"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}

# A CloudWatch Alarm that triggers if Multiple unauthorized actions or logins attempted. Alert sent to SOC at bofa
module "unauthorized_api_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  period            = 60
  metric_name       = "UnauthorizedAttemptCount"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers if Multiple unauthorized actions or logins attempted. Alert sent to SOC at bofa"
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}

# A CloudWatch Alarm that triggers when changes are made to IAM MFA devices (Virtual or Hardware). Events include
#  enabling/disabling/updating MFA virtual and hardware devices in an AWS account.
module "iam_mfa_change_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  period            = 300
  metric_name       = "IAMMFAEventCount"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers when changes are made to IAM MFA devices (Virtual or Hardware). Events include enabling/disabling/updating MFA virtual and hardware devices in an AWS account."
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{ ($.eventName = CreateVirtualMFADevice) || ($.eventName = DeactivateMFADevice) || ($.eventName = DeleteVirtualMFADevice) || ($.eventName = EnableMFADevice) || ($.eventName = ResyncMFADevice) }"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}

# A CloudWatch Alarm that triggers if there are AWS Management Console authentication failures.
module "console_auth_failed_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  period            = 300
  metric_name       = "ConsoleLoginFailures"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers if there are AWS Management Console authentication failures."
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failed authentication\") }"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}

# A CloudWatch Alarm that triggers if there is a Management Console sign-in without MFA.
module "console_login_without_mfa_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  period            = 60
  metric_name       = "ConsoleSigninWithoutMFA"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers if there is a Management Console sign-in without MFA."
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{($.eventName = ConsoleLogin) && ($.additionalEventData.MFAUsed != Yes) && ($.responseElements.ConsoleLogin != Failure) && ($.additionalEventData.SamlProviderArn NOT EXISTS) }"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}

# A CloudWatch Alarm that triggers when changes are made to an S3 Bucket Policy, ACL, LifeCycle, Replication, DeleteBucketPolicy, DeleteBucketCors, DeleteBucketReplication.
module "s3_policy_change_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  period            = 300
  metric_name       = "S3BucketActivityEventCount"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers when changes are made to an S3 Bucket Policy, ACL, LifeCycle, Replication, DeleteBucketPolicy, DeleteBucketCors, DeleteBucketReplication."
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{ ($.eventSource = s3.amazonaws.com) && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication)) }"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}

# A CloudWatch Alarm that triggers when changes are made to AWS Config.
module "config_change_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  period            = 300
  metric_name       = "ConfigChangeEventCount"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers when changes are made to AWS Config."
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{ ($.eventName = PutConfigurationRecorder) || ($.eventName = StopConfigurationRecorder) || ($.eventName = DeleteDeliveryChannel) || ($.eventName = PutDeliveryChannel) }"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}

# A CloudWatch Alarm that triggers if customer created CMKs get disabled or scheduled for deletion.
module "cmk_deletion_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  period            = 60
  metric_name       = "KMSCustomerKeyDeletion"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers if customer created CMKs get disabled or scheduled for deletion."
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{ ($.eventSource = kms.amazonaws.com) &&  (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) }"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}

# A CloudWatch Alarm that triggers when changes are made to IAM policies. Events include IAM policy creation/deletion/update operations as well as attaching/detaching policies from IAM users, roles or groups."
module "iam_policy_change_cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"

  period            = 300
  metric_name       = "IAMPolicyEventCount"
  metric_namespace  = "CloudTrailMetrics"
  alarm_description = "A CloudWatch Alarm that triggers when changes are made to IAM policies. Events include IAM policy creation/deletion/update operations as well as attaching/detaching policies from IAM users, roles or groups."
  log_group_name    = "aws-controltower/CloudTrailLogs"
  filter_pattern    = "{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}"
  alarm_actions     = [module.securitynotification_sns_region1.topic_arn]
}
