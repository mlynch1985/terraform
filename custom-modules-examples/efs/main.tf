resource "aws_efs_file_system" "this" {
  encrypted                       = true
  kms_key_id                      = var.kms_key_arn != "" ? var.kms_key_arn : null
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.throughput_mode == "provisioned" && var.provisioned_throughput != 0 ? var.provisioned_throughput : null
  throughput_mode                 = var.throughput_mode

  dynamic "lifecycle_policy" {
    for_each = var.enable_lifecycle_policy == true ? ["a"] : []

    content {
      transition_to_ia = "AFTER_30_DAYS"
    }
  }
}

resource "aws_efs_file_system_policy" "this" {
  file_system_id = aws_efs_file_system.this.id

  policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Id": "GrantAsgIamRole",
      "Statement": [
        {
          "Sid": "GrantAsgIamRole",
          "Effect": "Allow",
          "Principal": {
            "AWS": "${var.iam_role}"
          },
          "Resource": "${aws_efs_file_system.this.arn}",
          "Action": [
            "elasticfilesystem:DescribeMountTargets",
            "elasticfilesystem:ClientRootAccess",
            "elasticfilesystem:ClientMount",
            "elasticfilesystem:ClientWrite"
          ],
          "Condition": {
            "Bool": {
              "aws:SecureTransport": "true"
            }
          }
        }
      ]
    }
EOF
}

resource "aws_efs_mount_target" "this" {
  for_each = var.subnets

  file_system_id  = aws_efs_file_system.this.id
  security_groups = var.security_groups
  subnet_id       = each.value
}
