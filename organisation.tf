#Créer une organisation
resource "aws_organizations_organization" "Org" {

  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
  
}
#Creer des comptes
resource "aws_organizations_account" "account1" {
   
  name      = "CompteArchiveJournaux"
  email     = "cissekhady6120@gmail.com"
   role_name = "myOrganizationRole"

# Ajouter des comptes à cette unité d'organisation
    parent_id = aws_organizations_organizational_unit.CoreOU.id
  
}
resource "aws_organizations_account" "account2" {  
  name      = "CompteApplicatif"
  email     = "ckhady6120@gmail.com"
   role_name = "myOrganizationRole"

#Ajouter des comptes à cette unité d'organisation
    parent_id = aws_organizations_organizational_unit.CoreOU.id

}


# Creer une politique SCP

#resource "aws_organizations_policy" "security_policy" {

  #name = "my-scp"

  # Contenu de la politique
 # content = <<POLICY
#{

   # "Version": "2012-10-17",
    #"Statement": {
       # "Effect": "Deny",
        #"Action": [
        #    "s3:deny access",
         #   "logs:DeleteLogGroup"
            
        #],
        #"Resource": "*"    
   # }
#}
#POLICY
#}

# Créer une unité d'organisation 

resource "aws_organizations_organizational_unit" "CoreOU" {
  name      = "CoreOU"
  parent_id = aws_organizations_organization.Org.roots.0.id
  
}
# Attacher la politique SCP à l'OU
#resource "aws_organizations_policy_attachment" "attach" {
 # policy_id = aws_organizations_policy.my_scp.id
  #target_id = aws_organizations_organizational_unit.CoreOU.id
#}





   

