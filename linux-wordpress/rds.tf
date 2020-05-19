## Define RDS Instance with MYSQL Driver
resource "aws_db_instance" "rds-linuxwordpress" {
  identifier             = "${var.namespace}linuxwordpress"
  allocated_storage      = 20
  max_allocated_storage  = 100
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "${var.namespace}linuxwordpress"
  parameter_group_name   = "default.mysql5.7"
  username               = random_string.rds-user-linuxwordpress.result
  password               = random_password.rds-password-linuxwordpress.result
  db_subnet_group_name   = aws_db_subnet_group.subnet-group-linuxwordpress.name
  vpc_security_group_ids = ["${aws_security_group.allow-vpc-mysql.id}"]
  multi_az               = true
  apply_immediately      = true ## set to false for Production environments
  skip_final_snapshot    = true ## set to false for Production environments

  tags = {
    Name        = "${var.namespace}-rds-linuxwordpress"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define RDS Subnet Group in the Private Subnet zone
resource "aws_db_subnet_group" "subnet-group-linuxwordpress" {
  name       = "${var.namespace}-linuxwordpress"
  subnet_ids = data.aws_subnet_ids.private-subnets.ids

  tags = {
    Name        = "${var.namespace}-subnet-group-linuxwordpress"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Generate Random DB User Name
resource "random_string" "rds-user-linuxwordpress" {
  length  = 16
  special = false
}

## Generate Random DB User Password
resource "random_password" "rds-password-linuxwordpress" {
  length           = 16
  special          = true
  override_special = "_%@"
}

## Store our DB User Name in SSM Parameter Store
resource "aws_ssm_parameter" "ps-user-linuxwordpress" {
  name  = "${var.namespace}-user-linuxwordpress"
  value = random_string.rds-user-linuxwordpress.result
  type  = "String"
}

## Store our DB Password in SSM Parameter Store
resource "aws_ssm_parameter" "ps-password-linuxwordpress" {
  name  = "${var.namespace}-password-linuxwordpress"
  value = random_password.rds-password-linuxwordpress.result
  type  = "String"
}

## Store our DB Hostname in SSM Parameter Store
resource "aws_ssm_parameter" "ps-hostname-linuxwordpress" {
  name  = "${var.namespace}-hostname-linuxwordpress"
  value = aws_db_instance.rds-linuxwordpress.address
  type  = "String"
}

## Store our DB Name in SSM Parameter Store
resource "aws_ssm_parameter" "ps-name-linuxwordpress" {
  name  = "${var.namespace}-name-linuxwordpress"
  value = aws_db_instance.rds-linuxwordpress.identifier
  type  = "String"
}
