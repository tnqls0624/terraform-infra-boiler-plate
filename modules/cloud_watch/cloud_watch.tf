# Session Manager
resource "aws_cloudwatch_log_group" "ssm_session_logs" {
  name = "/aws/ssm/sessions"
  kms_key_id        = aws_kms_key.cloudwatch_logs_key.arn
  retention_in_days = 90
}