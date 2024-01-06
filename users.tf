#provider "aws" { 
  #  region = "us-east-1"
  #alias = "CompeDeGestion"
 # allowed_account_ids = [data.aws_caller_identity.current.account_id]
   
#}
data "aws_caller_identity" "current" {}
data "aws_iam_user" "user_one" {
  user_name = "Diarra"
}

resource "aws_iam_user" "user_one" {
 name = "Diarra"
}

resource "aws_iam_user" "user_two" { 
 name = "Fatim"
}

# Crée un groupe d'utilisateurs
resource "aws_iam_group" "developpeur" {
   
  name = "developpeur"
}
# Ajoute les utilisateurs au groupe
resource "aws_iam_group_membership" "developpeur" {
  name = "membre_groupe"
  
  users = [
    aws_iam_user.user_one.name,
    aws_iam_user.user_two.name, 
  ]

  group = aws_iam_group.developpeur.name
}
# Créer le rôle avec la politique lecture seule S3
resource "aws_iam_role" "s3_readonly" {
  name = "S3ReadOnly"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_policy" "S3_readonly_policy" {
  
    name = "S3ReadOnlyPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:Get*", "s3:List*"]
          Effect   = "Allow"
          Resource = [ "arn:aws:s3:::khady-bucket-log", "arn:aws:s3:::khady-bucket-log/*"]
        },
      ]
    })
  }

resource "aws_iam_user_policy_attachment" "attachement" {
  user       = data.aws_iam_user.user_one.user_name
  policy_arn = aws_iam_policy.S3_readonly_policy.arn
}
