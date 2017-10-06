#
# IAM Role for Threat Manager
#
resource "aws_iam_role" "alertlogic_tm_role" {
  name = "TerraForm_AlertLogic_Threat_Manager_Role"
  assume_role_policy = "${data.aws_iam_policy_document.alertlogic_tm_role.json}"
}

#
# Link policy to role
#
resource "aws_iam_role_policy_attachment" "alertlogic_tm_attachment" {
    role       = "${aws_iam_role.alertlogic_tm_role.name}"
    policy_arn = "${aws_iam_policy.alertlogic_tm_policy.arn}"
}

resource "aws_iam_policy" "alertlogic_tm_policy" {
  name = "TerraForm_Alertlogic_Threat_Manager_Policy"

  policy = "${data.aws_iam_policy_document.alertlogic_tm_policy.json}"
}

data "aws_iam_policy_document" "alertlogic_tm_role" {
  statement {

    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.alert_logic_aws_account_id}:root"]
    }
    condition {
      test = "StringEquals"
      variable = "sts:ExternalId"
      values = ["${var.alert_logic_external_id}"]
    }
  }
}

data "aws_iam_policy_document" "alertlogic_tm_policy" {
  statement {
    sid = "EnabledDiscoveryOfVariousAWSServices"

    actions = [
      "autoscaling:Describe*",
      "directconnect:Describe*",
      "elasticloadbalancing:Describe*",
      "ec2:Describe*",
      "rds:Describe*",
      "rds:DownloadDBLogFilePortion",
      "rds:ListTagsForResource",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:GetBucket*",
      "s3:GetObjectAcl",
      "s3:GetObjectVersionAcl",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid = "EnableCloudTrailIfAccountDoesntHaveCloudTrailsEnabled"

    actions = [
      "cloudtrail:*",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid = "CreateCloudTrailS3BucketIfCloudTrailsAreBeingSetupByAlertLogic"

    actions = [
      "s3:CreateBucket",
      "s3:PutBucketPolicy",
      "s3:DeleteBucket",
    ]

    resources = [
      "arn:aws:s3:::outcomesbucket-*"
    ]
  }

  statement {
    sid = "CreateCloudTrailsTopicTfOneWasntAlreadySetupForCloudTrails"

    actions = [
      "sns:CreateTopic",
      "sns:DeleteTopic",
    ]

    resources = [
      "arn:aws:sns:*:*:outcomestopic"
    ]
  }

  statement {
    sid = "MakeSureThatCloudTrailsSnsTopicIsSetupCorrectlyForCloudTrailPublishingAndSqsSubsription"

    actions = [
      "sns:addpermission",
      "sns:gettopicattributes",
      "sns:listtopics",
      "sns:settopicattributes",
      "sns:subscribe",
    ]

    resources = [
      "arn:aws:sns:*:*:*"
    ]
  }

  statement {
    sid = "BeAbleToValidateOurRoleAndDiscoverIAM"

    actions = [
      "iam:List*",
      "iam:Get*",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid = "CreateAlertLogicSqsQueueToSubscribeToCloudTrailsSnsTopicNotifications"

    actions = [
      "sqs:CreateQueue",
      "sqs:DeleteQueue",
      "sqs:SetQueueAttributes",
      "sqs:GetQueueAttributes",
      "sqs:ListQueues",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueUrl",
    ]

    resources = [
      "arn:aws:sqs:*:*:outcomesbucket*"
    ]
  }
}
