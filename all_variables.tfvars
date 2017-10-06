#AlertLogic Vars

# AWS account number for Cloud Insight and Threat Manager
# Use the default value below unless told otherwise
variable "alert_logic_aws_account_id" {
  default = "733251395267"
}

# External ID for IAM Cross Account Role, use some random number or your Alert Logic Customer ID
variable "alert_logic_external_id" {
  default = "123456" #can be any number over 6 digits.
}

# SNS arn that is used by CloudTrail
variable "cloudtrail_sns_arn" {
  default = "arn:aws:sns:REGION:ACCOUNT_NO:SNS_NAME"
}

# SNS arn that is used by CloudTrail
variable "cloudtrail_s3" {
  default = "YOUR_S3_BUCKET_NAME"
}

# AWS account number for Log Manager
# Use the default value below unless told otherwise
variable "alert_logic_lm_aws_account_id" {
  default = "239734009475"
}
