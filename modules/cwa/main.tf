resource "aws_ssm_parameter" "linux" {
  count = var.platform == "linux" ? 1 : 0

  name        = "/${var.namespace}/${var.app_role}/cwa_linux_config"
  type        = "String"
  description = "CloudWatch Agent configuration file for Linux servers"
  overwrite   = true

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_cwa_linux"
    )
  )

  value = var.config_json
}

resource "aws_ssm_parameter" "windows" {
  count = var.platform == "windows" ? 1 : 0

  name        = "/${var.namespace}/${var.app_role}/cwa_windows_config"
  type        = "String"
  description = "CloudWatch Agent configuration file for Wnidows servers"
  overwrite   = true

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_cwa_windows"
    )
  )

  value = var.config_json
}
