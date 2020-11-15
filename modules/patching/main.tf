resource "aws_ssm_maintenance_window" "this" {
  name              = "${var.namespace}_${var.app_role}_${var.schedule_name}"
  schedule          = var.schedule_cron
  schedule_timezone = var.schedule_timezone
  cutoff            = var.schedule_cutoff
  duration          = var.schedule_duration

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_${var.schedule_name}"
    )
  )
}

resource "aws_ssm_maintenance_window_target" "this" {
  name          = "${var.namespace}_${var.app_role}_${var.schedule_name}"
  window_id     = aws_ssm_maintenance_window.this.id
  resource_type = "INSTANCE"

  targets {
    key    = var.target_tag_name
    values = [var.target_tag_value]
  }
}

resource "aws_ssm_maintenance_window_task" "this" {
  name             = "${var.namespace}_${var.app_role}_${var.schedule_name}"
  window_id        = aws_ssm_maintenance_window.this.id
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors
  priority         = 1
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-RunPatchBaseline"
  service_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window.this.id]
  }
}
