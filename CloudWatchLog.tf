#Creer groupe de logs CloudWatch logs pour cloudTrail
resource "aws_cloudwatch_log_group" "cloudtrail_events" { 
    provider=aws.log 
  name = "khady-cloudtrail-log"
  retention_in_days = 365
}
#Role IAM pour autoriser Cloudtrail dans Cloudwatch
resource "aws_iam_role" "cloudtrail_to_logs" {
    provider = aws.log
  name = "CloudTrail-ToCloudWatch-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
inline_policy {
    name = "CloudTrail-Access" 
policy =<<POLICY
{

  "Version": "2012-10-17",  
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents" 
      ],
      "Effect": "Allow",
      "Resource": "${aws_cloudwatch_log_group.cloudtrail_events.arn}:*" 
    }
  ]
  
}
POLICY
}

  }