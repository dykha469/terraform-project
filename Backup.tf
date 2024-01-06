 #Créer le coffre de sauvegarde
resource "aws_backup_vault" "ec2_backup" {
  name = "ec2-backup-vault"
  provider = aws.dev
}

# Définir un plan de sauvegarde
resource "aws_backup_plan" "ec2_backup_plan" {
    provider = aws.dev
  name = "ec2-backup-plan"
  rule {
    rule_name = "weekly"
    target_vault_name = aws_backup_vault.ec2_backup.name
    schedule = "cron(0 0 ? * SUN *)"
    lifecycle {
      delete_after = 30
    }
  } 
  }
  resource "aws_backup_selection" "ec2_backup_selection" {
    name = "my_ec2_backup"
    provider = aws.dev
    plan_id = aws_backup_plan.ec2_backup_plan.id
    iam_role_arn = "arn:aws:iam::224078010398:role/aws-service-role/backup.amazonaws.com/AWSServiceRoleForBackup"
    selection_tag {
    type = "STRINGEQUALS"
    key = "backup"
    value = "weekly"
  }
  resources = [ aws_instance.instance.arn]

}
    
  