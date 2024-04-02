resource "aws_iam_role" "ssm_logging_role" {
  name = "SSMLoggingRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_policy" "ssm_logging_policy" {
  name        = "SSMLoggingPolicy"
  description = "Policy for allowing SSM to log to CloudWatch Logs."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_logging" {
  role       = aws_iam_role.ssm_logging_role.name
  policy_arn = aws_iam_policy.ssm_logging_policy.arn
}
