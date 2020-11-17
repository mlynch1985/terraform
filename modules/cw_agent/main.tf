resource "aws_ssm_parameter" "linux_parameter" {
  count = var.linux_config != "" ? 1 : 0

  name        = "/${var.namespace}/${var.component}/cwa/linux"
  type        = "String"
  description = "CloudWatch Agent configuration file for Linux servers"
  overwrite   = true
  value       = var.linux_config

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/cwa/linux"
    )
  )
}

resource "aws_ssm_parameter" "windows_parameter" {
  count = var.windows_config != "" ? 1 : 0

  name        = "/${var.namespace}/${var.component}/cwa/windows"
  type        = "String"
  description = "CloudWatch Agent configuration file for Wnidows servers"
  overwrite   = true
  value       = var.windows_config

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/cwa_windows"
    )
  )
}
