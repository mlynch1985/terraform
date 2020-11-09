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

resource "aws_ssm_association" "this" {
  count = var.enable_auto_join ? 1 : 0

  depends_on       = [aws_directory_service_directory.this]
  name             = "AWS-JoinDirectoryServiceDomain"
  association_name = "${var.namespace}_${var.app_role}_ad_autojoin"
  compliance_severity = "HIGH"
  max_errors          = 5

  targets {
    key    = "tag:${var.ad_target_tag_name}"
    values = [var.ad_target_tag_value]
  }
  parameters = {
    directoryId   = aws_directory_service_directory.this.id
    directoryName = aws_directory_service_directory.this.name
  }
}

resource "aws_vpc_dhcp_options" "this" {
  count = var.enable_auto_join ? 1 : 0

  depends_on          = [aws_directory_service_directory.this]
  domain_name         = var.domain_name
  domain_name_servers = aws_directory_service_directory.this.dns_ip_addresses

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_dhcp_options"
    )
  )
}

resource "aws_vpc_dhcp_options_association" "this" {
  count = var.enable_auto_join ? 1 : 0

  depends_on      = [aws_directory_service_directory.this]
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id
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
  "root_password": "${random_password.password.result}",
  "directory_id": "${aws_directory_service_directory.this.id},
  "dns_ip_addresses": [
    "${tolist(aws_directory_service_directory.this.dns_ip_addresses)[0]}",
    "${tolist(aws_directory_service_directory.this.dns_ip_addresses)[1]}"
  ]
}
EOF
}
