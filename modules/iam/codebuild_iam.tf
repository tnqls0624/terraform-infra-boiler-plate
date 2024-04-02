# Code Build Iam
data "aws_iam_policy_document" "code_build" {
  version = "2012-10-17"

  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["codebuild.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy" "AmazonEC2ContainerRegistryFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

data "aws_iam_policy" "AmazonECS_FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

data "aws_iam_policy" "CodePipeline_FullAccess" {
  arn = aws_iam_policy.CodePipeline_FullAccess.arn
}

data "aws_iam_policy" "CodeBuildBasePolicy" {
  arn = aws_iam_policy.CodeBuildBasePolicy.arn
}

data "aws_iam_policy_document" "CodeBuildBasePolicy" {
  version = "2012-10-17"
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue"
    ]

    // 특정 프로젝트에 종속하지 않고, 모든 CodeBuild를 사용할 수 있는 권한 부여
    resources = [
      "arn:aws:logs:${var.aws_config.region}:${var.aws_config.account_id}:log-group:/aws/codebuild/*",
      "arn:aws:logs:${var.aws_config.region}:${var.aws_config.account_id}:log-group:/aws/codebuild/*:*"
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]

    resources = ["*"]
  }

}

# IAM Policy
resource "aws_iam_policy" "CodeBuildBasePolicy" {
  name   = "${var.name}-${var.env}-CodeBuildBasePolicy"
  policy = data.aws_iam_policy_document.CodeBuildBasePolicy.json

  tags = {
    name = "${var.name}-${var.env}-CodeBuildBasePolicy"
    env  = var.env
  }
}

# IAM Role
resource "aws_iam_role" "code_build" {
  name = "${var.name}-${var.env}-CodeBuildServiceRole"

  assume_role_policy  = data.aws_iam_policy_document.code_build.json
  managed_policy_arns = [
    data.aws_iam_policy.AmazonEC2ContainerRegistryFullAccess.arn,
    data.aws_iam_policy.AmazonECS_FullAccess.arn,
    data.aws_iam_policy.AmazonS3FullAccess.arn,
    aws_iam_policy.CodeBuildBasePolicy.arn
  ]

  tags = {
    name = "${var.name}-${var.env}-CodeBuildServiceRole"
    env  = var.env
  }
}

# IAM Policy
resource "aws_iam_policy" "CodePipeline_FullAccess" {
  name   = "${var.name}-${var.env}-CodePipeline_FullAccess"
  policy = data.aws_iam_policy_document.CodePipeline_FullAccess.json

  tags = {
    Name = "${var.name}-${var.env}-CodePipeline_FullAccess"
    env  = var.env
  }
}


# Code Pipeline Iam

data "aws_iam_policy_document" "code_pipeline" {
  version = "2012-10-17"

  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["codepipeline.amazonaws.com"]
      type        = "Service"
    }
  }
}

# TODO: 하나의 Policy가 너무 많은 책임을 가지고 있음.
data "aws_iam_policy_document" "CodePipeline_FullAccess" {
  version = "2012-10-17"

  statement {
    actions = ["iam:PassRole"]

    condition {
      test     = "StringEqualsIfExists"
      variable = "iam:PassedToService"
      values   = [
        "cloudformation.amazonaws.com",
        "elasticbeanstalk.amazonaws.com",
        "ec2.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }

    resources = ["*"]
  }

  statement {
    actions = [
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetRepository",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision"
    ]

    resources = ["*"]
  }

  statement {
    actions = ["codestar-connections:UseConnection"]

    resources = ["*"]
  }

  # FIXME: Full Access Action이 너무 많음.
  statement {
    actions = [
      "elasticbeanstalk:*",
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:*"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "lambda:InvokeFunction",
      "lambda:ListFunctions"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "opsworks:CreateDeployment",
      "opsworks:DescribeApps",
      "opsworks:DescribeCommands",
      "opsworks:DescribeDeployments",
      "opsworks:DescribeInstances",
      "opsworks:DescribeStacks",
      "opsworks:UpdateApp",
      "opsworks:UpdateStack"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "cloudformation:CreateStack",
      "cloudformation:DeleteStack",
      "cloudformation:DescribeStacks",
      "cloudformation:UpdateStack",
      "cloudformation:CreateChangeSet",
      "cloudformation:DeleteChangeSet",
      "cloudformation:DescribeChangeSet",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:SetStackPolicy",
      "cloudformation:ValidateTemplate"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:BatchGetBuildBatches",
      "codebuild:StartBuildBatch"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "devicefarm:ListProjects",
      "devicefarm:ListDevicePools",
      "devicefarm:GetRun",
      "devicefarm:GetUpload",
      "devicefarm:CreateUpload",
      "devicefarm:ScheduleRun"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "servicecatalog:ListProvisioningArtifacts",
      "servicecatalog:CreateProvisioningArtifact",
      "servicecatalog:DescribeProvisioningArtifact",
      "servicecatalog:DeleteProvisioningArtifact",
      "servicecatalog:UpdateProduct"
    ]

    resources = ["*"]
  }

  statement {
    actions = ["cloudformation:ValidateTemplate"]

    resources = ["*"]
  }

  statement {
    actions = ["ecr:DescribeImages"]

    resources = ["*"]
  }

  statement {
    actions = [
      "states:DescribeExecution",
      "states:DescribeStateMachine",
      "states:StartExecution"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "appconfig:StartDeployment",
      "appconfig:StopDeployment",
      "appconfig:GetDeployment"
    ]

    resources = ["*"]
  }
}

# IAM Role
resource "aws_iam_role" "code_pipeline" {
  name = "${var.name}-${var.env}-CodePipelineServiceRole"

  assume_role_policy  = data.aws_iam_policy_document.code_pipeline.json
  managed_policy_arns = [aws_iam_policy.CodePipeline_FullAccess.arn]

  tags = {
    name = "${var.name}-${var.env}-CodePipelineServiceRole"
    env  = var.env
  }
}
