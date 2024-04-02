# IAM Role Trusted entities
data "aws_iam_policy_document" "ecs_task_execution" {
  version = "2012-10-17"

  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# TODO: IAM Policy의 유형이 AWS 관리형을 가지고 있음, 추후 수정이 필요.
# IAM Policy
data "aws_iam_policy" "ECS_FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy" "S3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

data "aws_iam_policy" "AmazonSNSFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

data "aws_iam_policy" "AmazonSQSFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

data "aws_iam_policy" "CloudWatchFullAccess" {
  arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

#data "aws_iam_policy_document" "opensearch_policy" {
#  statement {
#    actions = [
#      "es:*"
#    ]
#    resources = ["*"]
#  }
#}

#resource "aws_iam_policy" "opensearch_policy" {
#  name   = "${var.project.name}-${var.project.env}-OpenSearchPolicy"
#  policy = data.aws_iam_policy_document.opensearch_policy.json
#
#  tags = {
#    Name = "${var.project.name}-${var.project.env}-OpenSearchPolicy"
#    env  = var.project.env
#  }
#}

# IAM Role
resource "aws_iam_role" "ecs_task_execution" {
  name                = "${var.name}-${var.env}-ecsTaskExecutionRole"
  assume_role_policy  = data.aws_iam_policy_document.ecs_task_execution.json
  managed_policy_arns = [
    data.aws_iam_policy.ECS_FullAccess.arn,
    data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn,
    data.aws_iam_policy.S3FullAccess.arn,
    data.aws_iam_policy.AmazonSNSFullAccess.arn,
    data.aws_iam_policy.AmazonSQSFullAccess.arn,
    data.aws_iam_policy.CloudWatchFullAccess.arn,
    #    aws_iam_policy.opensearch_policy.arn,
  ]

  tags = {
    name = "${var.name}-${var.env}-ecsTaskExecutionRole"
    env  = var.env
  }
}
