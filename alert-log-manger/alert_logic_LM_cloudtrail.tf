#
# SQS to read data from CloudTrail
#
resource "aws_sqs_queue" "alertlogic_lm_cloudtrail_sqs" {
  name = "TerraForm_AlertLogic_LM_CloudTrail_SQS"
}

#
# SQS policy to subscribe to CloudTrail SNS
#
resource "aws_sqs_queue_policy" "alertlogic_lm_cloudtrail_sqs_policy" {
  queue_url = "${aws_sqs_queue.alertlogic_lm_cloudtrail_sqs.id}"
  policy = "${data.aws_iam_policy_document.alertlogic_lm_cloudtrail_sqs_policy.json}"
}

data "aws_iam_policy_document" "alertlogic_lm_cloudtrail_sqs_policy" {

    policy_id = "sqspolicy"
    statement {
      sid = "1"


      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      actions = [
        "sqs:SendMessage",
      ]

      resources = [
        "${aws_sqs_queue.alertlogic_lm_cloudtrail_sqs.arn}",
      ]

      condition {
        test     = "ArnEquals"
        variable = "aws:SourceArn"

        values = [
          "${var.cloudtrail_sns_arn}",
      ]
    }
  }
}
#
# Subscribe SQS to CloudTrail SNS
#
resource "aws_sns_topic_subscription" "alertlogic_lm_cloudtrail_sqs_subscribe" {
  topic_arn = "${var.cloudtrail_sns_arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.alertlogic_lm_cloudtrail_sqs.arn}"
}

#
# IAM Role for Log Manager to collect CloudTrail
#

data "aws_iam_policy_document" "alertlogic_lm_cloudtrail_role" {
    statement {
      sid = "1"

      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${var.alert_logic_lm_aws_account_id}:root"]
      }

      actions = [
        "sts:AssumeRole",
      ]

      condition {
        test     = "StringEquals"
        variable = "sts:ExternalId"

        values = [
          "${var.alert_logic_external_id}",
      ]
    }
  }
}

resource "aws_iam_role" "alertlogic_lm_cloudtrail_role" {
  name = "TerraForm_AlertLogic_Log_Manager_CloudTrail_Role"
  assume_role_policy = "${data.aws_iam_policy_document.alertlogic_lm_cloudtrail_role.json}"
}

#
# IAM Policy for Log Manager to collect CloudTrail
#

data "aws_iam_policy_document" "alertlogic_lm_cloudtrail_policy" {
    statement {
      sid = "1"

      actions = [
        "sqs:GetQueueUrl",
        "sqs:Receivemessage",
        "sqs:DeleteMessage",
      ]

      resources = [
        "${aws_sqs_queue.alertlogic_lm_cloudtrail_sqs.arn}",
      ]
    }
    statement {

      sid = "2"

      actions = [
          "s3:GetObject",
      ]

      resources = [
        "arn:aws:s3:::${var.cloudtrail_s3}/*",
      ]
    }
  }

resource "aws_iam_policy" "alertlogic_lm_cloudtrail_policy" {
  name = "TerraForm_Alertlogic_Log_Manager_CloudTrail_Policy"
  policy = "${data.aws_iam_policy_document.alertlogic_lm_cloudtrail_policy.json}"
}
#
# Link policy to role
#
resource "aws_iam_role_policy_attachment" "alertlogic_lm_cloudtrail_attachment" {
    role       = "${aws_iam_role.alertlogic_lm_cloudtrail_role.name}"
    policy_arn = "${aws_iam_policy.alertlogic_lm_cloudtrail_policy.arn}"
}
