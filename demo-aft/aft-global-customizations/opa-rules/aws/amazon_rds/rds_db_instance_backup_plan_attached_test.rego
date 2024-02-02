package aws.amazon_rds.rds_db_instance_backup_plan_attached

test_rds_db_instance_backup_plan_attached_ignore {
    count(violations) == 0 with input as data.rds_db_instance_backup_plan_attached.ignore
}

test_rds_db_instance_backup_plan_attached_valid {
    count(violations) == 0 with input as data.rds_db_instance_backup_plan_attached.valid
}

test_rds_db_instance_backup_plan_attached_invalid {
    r = violations with input as data.rds_db_instance_backup_plan_attached.invalid
    count(r) == 1 
    r[_]["finding"]["title"] = "RDS_DB_INSTANCE_BACKUP_PLAN_ATTACHED"
    r[_]["finding"]["uid"] = "RDS-8"
}

test_rds_db_instance_backup_plan_attached_no_automatic_backups {
    r = violations with input as data.rds_db_instance_backup_plan_attached.no_automatic_backups
    count(r) == 1 
    r[_]["finding"]["title"] = "RDS_DB_INSTANCE_BACKUP_PLAN_ATTACHED"
    r[_]["finding"]["uid"] = "RDS-8"
}

test_rds_db_instance_backup_plan_attached_no_backup_plan {
    r = violations with input as data.rds_db_instance_backup_plan_attached.no_backup_plan
    count(r) == 1 
    r[_]["finding"]["title"] = "RDS_DB_INSTANCE_BACKUP_PLAN_ATTACHED"
    r[_]["finding"]["uid"] = "RDS-8"
}