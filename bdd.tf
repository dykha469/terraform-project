
#configuration BDD Mysql
resource "aws_db_instance" "my_db" {
    
    provider = aws.dev
  allocated_storage    = 100
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.33"
  instance_class       = "db.t2.micro"
  username             = "dykha"
  password             = "dykha1997"
  parameter_group_name = "default.mysql8.0"
  backup_retention_period = 0

  tags = {
    Name = "my_db"
  }
}
#Configuration du plan de backup

resource "aws_backup_vault" "db_backup" {
  provider = aws.dev
  name = "mydb-backup-vault" 
}
resource "aws_backup_plan" "db_weekly_backup" {
  provider = aws.dev
  name = "mydb-backup-plan"
  rule {
    rule_name = "weekly"
    target_vault_name = aws_backup_vault.db_backup.name
    schedule = "cron(0 0 ? * SUN *)"
    lifecycle {
      delete_after = 30
    }
  } 
}
resource "aws_backup_selection" "db_backup_selection" {
  provider = aws.dev
  name = "mydb-backup"
  plan_id = aws_backup_plan.db_weekly_backup.id

  iam_role_arn = "arn:aws:iam::224078010398:role/aws-service-role/backup.amazonaws.com/AWSServiceRoleForBackup"
  selection_tag {
    type = "STRINGEQUALS"
    key = "backup"
    value = "weekly"
  }
  resources = [ aws_db_instance.my_db.arn ]
}



