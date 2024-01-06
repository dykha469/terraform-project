
#Configuration CloudTrail trail
data "aws_organizations_organization" "Org" {}
resource "aws_cloudtrail" "mytrail" {
  provider = aws.log
  name           = "trail-khady"
  s3_bucket_name = aws_s3_bucket.khady-bucket-log.bucket
  cloud_watch_logs_role_arn     = "arn:aws:iam::894522627426:role/CloudTrail-ToCloudWatch-role"
  depends_on = [aws_s3_bucket_policy.CloudTrailS3Bucket]

#Envoyer des evenements dans CloudWatch Logs
cloud_watch_logs_group_arn = "arn:aws:logs:us-east-1:894522627426:log-group:khady-cloudtrail-log:*"
 
#Journaliser les appels d'API
event_selector {
    read_write_type = "All"
    include_management_events = true
    data_resource {
      type = "AWS::S3::Object"
      values = [
        "arn:aws:s3:::khady-bucket-log/*"
      ]
    }
  }
 
    
  #Appliquer le trail uniquement au compte master
   is_organization_trail = false
   #id = "arn:aws:organizations::018038634762:account/o-gp2an4y5rh/018038634762"
    

}