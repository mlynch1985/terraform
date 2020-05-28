## Define Maintenance Window
resource "aws_ssm_maintenance_window" "kms_server_patching" {
  name                       = "KMS-Server-Patching"
  schedule                   = "cron(0 0 2 ? * WED *)"
  cutoff                     = 0
  duration                   = 3
  allow_unassociated_targets = false
  schedule_timezone          = "US/Eastern"
}

## Define Maintenance Targets
resource "aws_ssm_maintenance_window_target" "kms_server_patching" {
  window_id     = aws_ssm_maintenance_window.kms_server_patching.id
  name          = "KMS-Server-Patching"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Name"
    values = ["${var.namespace}_windowsJump"]
  }
}

## Define the Patch Task
resource "aws_ssm_maintenance_window_task" "kms_server_patching" {
  max_concurrency  = 2
  max_errors       = 1
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-RunPatchBaseline"
  service_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
  window_id        = aws_ssm_maintenance_window.kms_server_patching.id
  priority         = 1

  targets {
    key    = "WindowTargetIds"
    values = ["${aws_ssm_maintenance_window.kms_server_patching.id}"]
  }
}
