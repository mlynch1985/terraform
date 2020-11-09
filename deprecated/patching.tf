resource "aws_ssm_maintenance_window" "patching" {
    name = "sample-winiis-patching"
    schedule = "cron(0 0 2 ? * WED *)"
    cutoff = 0
    duration = 3
    allow_unassociated_targets = false
    schedule_timezone = "US/Eastern"
}

resource "aws_ssm_maintenance_window_target" "patching" {
    window_id = aws_ssm_maintenance_window.patching.id
    name = "sample-winiis-patching"
    resource_type = "INSTANCE"
    targets {
        key = "tag:Name"
        values = ["sample-winiis"]
    }
}

resource "aws_ssm_maintenance_window_task" "patching" {
    max_concurrency = 2
    max_errors = 1
    task_type = "RUN_COMMAND"
    task_arn = "AWS-RunPatchBaseline"
    service_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
    window_id  = aws_ssm_maintenance_window.patching.id
    priority = 1
    targets {
        key = "WindowTargetIds"
        values = ["${aws_ssm_maintenance_window.patching.id}"]
    }
}
