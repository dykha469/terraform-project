
 #Créer le bucket S3  
resource "aws_s3_bucket" "khady-bucket-log" {
    provider = aws.log
  bucket = "khady-bucket-log"

 lifecycle {
       prevent_destroy = true
    
   }
   
  tags = {
    Name   = "khady-bucket-log"
     acl = "public"
    Environment = "Log"  
  } 
}
#politique d'accès au bucket S3 pour cloudtrail

resource "aws_s3_bucket_policy" "CloudTrailS3Bucket"{
provider = aws.log
bucket = "khady-bucket-log"
  policy = <<POLICY
  {
 "Version": "2012-10-17",
 "Statement":[
 {
   "Sid": "AWSCloudTrailAclCheck",
   "Effect": "Allow",
   "Principal": {
     "Service": "cloudtrail.amazonaws.com"
},
"Action": "s3:GetBucketAcl",
"Resource": "arn:aws:s3:::khady-bucket-log"
  },
  {
    "Sid": "AWSCloudTrailWrite",
    "Effect": "Allow",
     "Principal": {
       "Service": "cloudtrail.amazonaws.com"
  },
    "Action": "s3:PutObject",
    "Resource": "arn:aws:s3:::khady-bucket-log/*"
}
]
}
POLICY
}

resource "aws_iam_role" "bucket_role" {
  name = "CloudTrailS3AccessRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}






#resource "aws_iam_policy_attachment" "cloudtrail_s3_policy_attachment" {

 # name       = "CloudTrailS3PolicyAttachment"
  #roles      = [aws_iam_role.bucket_role.name]
  #policy_arn = aws_iam_policy.CloudTrailS3Bucket.arn
#}
#COnfigurer une politique d'accès S3 pour cloudtrail

#resource "aws_iam_policy" "cloudtrail_s3_policy" {
 #   provider = aws.log
  #name        = "CloudTrailS3AccessPolicy"
  
  #policy = jsonencode({
   # Version = "2012-10-17",
    #Statement = [{
     # Effect    = "Allow",
      #Action    = [
       # "s3:GetBucketAcl",
        #"s3:PutObject",
        #"s3:*"
      #],
     # Resource  = [
      # "arn:aws:s3:::khady-bucket-log",
       # "arn:aws:s3:::khady-bucket-log/AWSLogs/8945-2262-7426/*"
      #]
    #}]
  #})
#}




