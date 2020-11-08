resource "aws_efs_file_system" "this" {
  encrypted                       = var.is_encrypted
  performance_mode                = var.performance_mode

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.name}"
    )
  )
}

resource "aws_efs_mount_target" "this" {
  count = length(var.subnets)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.subnets[count.index]
  security_groups = var.security_groups
}

resource "aws_ssm_parameter" "this" {
  name  = "/${var.namespace}/${var.name}/efs_mount"
  type  = "String"
  value = aws_efs_file_system.this.id
}
