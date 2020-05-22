## Define RDS Instance with MYSQL Driver
resource "aws_db_instance" "linuxwordpress" {
  identifier             = "${var.namespace}linuxwordpress"
  allocated_storage      = 20
  max_allocated_storage  = 100
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "${var.namespace}linuxwordpress"
  parameter_group_name   = "default.mysql5.7"
  username               = random_string.linuxwordpress_username.result
  password               = random_password.linuxwordpress_password.result
  db_subnet_group_name   = aws_db_subnet_group.linuxwordpress.name
  vpc_security_group_ids = ["${aws_security_group.allow_vpc_mysql.id}"]
  multi_az               = true
  apply_immediately      = true ## set to false for Production environments
  skip_final_snapshot    = true ## set to false for Production environments

  tags = {
    Name        = "${var.namespace}_linuxwordpress_rds"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define RDS Subnet Group in the Private Subnet zone
resource "aws_db_subnet_group" "linuxwordpress" {
  name       = "${var.namespace}_linuxwordpress_subnetgroup"
  subnet_ids = data.aws_subnet_ids.subnets_private.ids

  tags = {
    Name        = "${var.namespace}_linuxwordpress_subnetgroup"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Generate Random DB User Name
resource "random_string" "linuxwordpress_username" {
  length  = 12
  special = false
}

## Generate Random DB User Password
resource "random_password" "linuxwordpress_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

## Store our DB User Name in SSM Parameter Store
resource "aws_ssm_parameter" "linuxwordpress_username" {
  name  = "${var.namespace}_linuxwordpress_username"
  value = random_string.linuxwordpress_username.result
  type  = "String"
}

## Store our DB Password in SSM Parameter Store
resource "aws_ssm_parameter" "linuxwordpress_password" {
  name  = "${var.namespace}_linuxwordpress_password"
  value = random_password.linuxwordpress_password.result
  type  = "String"
}

## Store our DB Hostname in SSM Parameter Store
resource "aws_ssm_parameter" "linuxwordpress_hostname" {
  name  = "${var.namespace}_linuxwordpress_hostname"
  value = aws_db_instance.linuxwordpress.address
  type  = "String"
}

## Store our DB Name in SSM Parameter Store
resource "aws_ssm_parameter" "linuxwordpress_dbname" {
  name  = "${var.namespace}_linuxwordpress_dbname"
  value = aws_db_instance.linuxwordpress.identifier
  type  = "String"
}
