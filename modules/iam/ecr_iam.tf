resource "aws_iam_policy" "ECR_FullAccess" {
  name        = "${var.name}-${var.env}-ECR_FullAccess"
  description = "Allow push and pull images from ECR"

  policy = data.aws_iam_policy_document.ecr.json

  tags = {
    Name = "${var.name}-${var.env}-ECR_FullAccess"
    env  = var.env
  }
}

data "aws_iam_policy_document" "ecr" {
  statement {
    sid    = "AllowPushPull"
    effect = "Allow"

    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:DescribeRepositories",
      "ecr:DescribeImages",
      "ecr:ListImages",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowGetAuthorizationToken"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }
}