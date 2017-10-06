#
# Module for Cloud Insight Cross Account Role
# Output the IAM role ARN to be inputed back to Alert Logic Cloud Insight UI
#
module "cloud_insight_role" {
  source = "./CI_CrossAccount"

  alert_logic_aws_account_id = "${var.alert_logic_aws_account_id}"
  alert_logic_external_id    = "${var.alert_logic_external_id}"
}

#
# Module for Threat Manager Cross Account Role
# Output the IAM role ARN to be inputed back to Alert Logic Cloud Defender UI
#
module "threat_manager_role" {
  source = "./TM_CrossAccount"

  alert_logic_aws_account_id = "${var.alert_logic_aws_account_id}"
  alert_logic_external_id    = "${var.alert_logic_external_id}"
}

#
# Module for Log Manager Cross Account Role
# Output the IAM role ARN and SQS name to be inputed back to Alert Logic Log Manager Cloud Trail source
#
module "log_manager_cloudtrail" {
  source = "./LM_CloudTrail"

  alert_logic_aws_account_id    = "${var.alert_logic_aws_account_id}"
  alert_logic_external_id       = "${var.alert_logic_external_id}"
  cloudtrail_sns_arn            = "${var.cloudtrail_sns_arn}"
  cloudtrail_s3                 = "${var.cloudtrail_s3}"
  alert_logic_lm_aws_account_id = "${var.alert_logic_lm_aws_account_id}"
}

#Threat Manger Instance

module "threat_manger_instance" {
  source = "./Threat_Manger_Instance"

  instance_count   = "1"
  primary_key_pair = ""
  vpc_id           = ""
  sn               = []
  zones            = []
  instance_type    = "c4.xlarge"
  tag_name         = "threat_manger"
  claimCIDR        = ""
  monitoringCIDR   = ""
  puppet_env       = "${var.env_name}" # Envirment Name
}
