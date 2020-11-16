resource "random_password" "username" {
  length  = 8
  special = false
}

resource "random_password" "password" {
  length           = 18
  special          = false
  override_special = "/@"
}

resource "aws_db_subnet_group" "this" {
  name_prefix = "${var.namespace}_${var.component}_subnet_group_"
  subnet_ids  = var.subnets

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/subnet_group"
    )
  )
}

resource "aws_rds_cluster" "this" {
  availability_zones        = var.availability_zones
  cluster_identifier_prefix = "${var.namespace}-${var.component}-"
  database_name             = "${var.component}DB"
  db_subnet_group_name      = aws_db_subnet_group.this.id
  engine_mode               = "serverless"
  engine                    = "aurora"
  master_username           = random_password.username.result
  master_password           = random_password.password.result
  skip_final_snapshot       = true
  vpc_security_group_ids    = var.security_groups

  scaling_configuration {
    auto_pause               = true
    max_capacity             = 256
    min_capacity             = 2
    seconds_until_auto_pause = 300
  }

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/rds_cluster"
    )
  )
}

resource "aws_secretsmanager_secret" "this" {
  name                    = "/${var.namespace}/${var.component}/rds"
  recovery_window_in_days = 0

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/rds"
    )
  )
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = <<EOF
{
  "username": "${random_password.username.result}",
  "password": "${random_password.password.result}",
  "cluster_identifier": "${aws_rds_cluster.this.cluster_identifier}",
  "endpoint": "${aws_rds_cluster.this.endpoint}",
  "database_name": "${aws_rds_cluster.this.database_name}"
}
EOF
}
