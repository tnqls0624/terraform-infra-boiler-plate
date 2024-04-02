resource "aws_kms_key" "cloudwatch_logs_key" {
  description             = "KMS key for encrypting CloudWatch Logs"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
      {
        "Sid": "Enable IAM User Permissions",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::637423210024:root"
        },
        "Action": "kms:*",
        "Resource": "*"
      },
      {
        "Sid": "Allow CloudWatch Logs use of the key",
        "Effect": "Allow",
        "Principal": {
          "Service": "logs.ap-northeast-2.amazonaws.com"
        },
        "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource": "*",
        "Condition": {
          "ArnLike": {
            "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:ap-northeast-2:637423210024:*"
          }
        }
      }
    ]
  }
  POLICY
}

resource "aws_kms_alias" "cloudwatch_logs_key_alias" {
  name          = "alias/cloudwatchLogsKey"
  target_key_id = aws_kms_key.cloudwatch_logs_key.key_id
}