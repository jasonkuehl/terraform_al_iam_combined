output "alertlogic_lm_cloudtrail_target_iam_role_arn" {
  value = "${aws_iam_role.alertlogic_lm_cloudtrail_role.arn}"
}

output "alertlogic_lm_cloudtrail_target_sqs_name" {
  value = "${aws_sqs_queue.alertlogic_lm_cloudtrail_sqs.name}"
}
