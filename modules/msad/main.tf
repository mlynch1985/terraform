provider "random" {}

resource "aws_iam_role_policy_attachment" "msad" {
  role       = var.iam_ec2_role
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}

resource "random_password" "password" {
  length           = 24
  special          = true
  override_special = "/@"
}

resource "aws_directory_service_directory" "this" {
  name       = var.domain_name
  password   = random_password.password.result
  alias      = var.enable_sso ? var.component : null
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
      "Name", "${var.namespace}/${var.component}/directory"
    )
  )
}

resource "aws_ssm_association" "this" {
  count = var.enable_auto_join ? 1 : 0

  depends_on          = [aws_directory_service_directory.this]
  name                = "AWS-JoinDirectoryServiceDomain"
  association_name    = "${var.namespace}_${var.component}_ad_autojoin"
  compliance_severity = "HIGH"
  max_errors          = 5

  targets {
    key    = var.ad_target_tag_name
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
      "Name", "${var.namespace}/${var.component}/dhcp_options"
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
  name                    = "/${var.namespace}/${var.component}/msad"
  recovery_window_in_days = 0

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/msad"
    )
  )
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = <<-EOF
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
