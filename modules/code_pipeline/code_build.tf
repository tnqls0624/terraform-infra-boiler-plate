locals {
  ecs_container_name = "${var.name}-${var.project.sub_name}-container-${var.env}"
}

resource "aws_codebuild_project" "this" {
  name = "${var.name}-${var.project.sub_name}-codebuild-${var.env}"

  build_timeout      = 60
  queued_timeout     = 480
  badge_enabled      = false
  project_visibility = "PRIVATE"
  service_role       = var.iam_code_build_arn
  encryption_key     = "arn:aws:kms:${var.aws_config.region}:${var.aws_config.account_id}:alias/aws/s3"

  artifacts {
    name                   = "${var.name}-${var.project.sub_name}-codebuild-${var.env}"
    encryption_disabled    = false
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

#  cache {
#    type  = "S3"ㅛ
#    location = "${var.s3.bucket_name}/cache/${var.env}/${var.name}-${var.project.sub_name}"
#  }

  environment {
    type = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "ENV_MODE"
      value = var.env
    }

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_config.region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_config.account_id
    }

    environment_variable {
      name  = "PROJECT_NAME"
      value = var.name
    }

    environment_variable {
      name  = "PROJECT_SUB_NAME"
      value = var.project.sub_name
    }

    environment_variable {
      name  = "SPRING_PROFILE"
      value = var.env
    }

    environment_variable {
      name  = "ECR_REPOSITORY_URL"
      value = "${var.aws_config.account_id}.dkr.ecr.${var.aws_config.region}.amazonaws.com/${var.ecr.name}"
    }

    environment_variable {
      name  = "ECS_CONTAINER_NAME"
      value = local.ecs_container_name
    }

    // 추가 환경 변수가 필요한 경우 여기에 추가
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    buildspec           = "buildspec.yml"
    type                = "CODEPIPELINE"
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
  }

  tags = {
    name = "${var.name}-${var.project.sub_name}-codebuild-${var.env}"
    env  = var.env
  }
}
