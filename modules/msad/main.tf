resource "random_password" "password" {
  length           = 24
  special          = true
  override_special = "/@"
}

resource "aws_directory_service_directory" "this" {
  name       = var.domain_name
  password   = random_password.password.result
  alias      = var.enable_sso ? var.app_role : null
  enable_sso = var.enable_sso
  type       = "MicrosoftAD"
  edition    = var.edition

  vpc_settings {
    subnet_ids = [var.subnet_1, var.subnet_2]
    vpc_id     = var.vpc_id
  }

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_directory"
    )
  )
}

resource "aws_secretsmanager_secret" "this" {
  name = "${var.namespace}_${var.app_role}_msad"

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_msad"
    )
  )
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = <<EOF
{
  "directory_id": "${aws_directory_service_directory.this.id},
  "dns_ip_addresses": "${aws_directory_service_directory.this.dns_ip_addresses},
  "root_password": "${random_password.password.result}"
}
EOF
}
