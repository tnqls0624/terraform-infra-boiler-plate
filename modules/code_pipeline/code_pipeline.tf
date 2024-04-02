resource "aws_codepipeline" "this" {
  name     = "${var.name}-${var.project.sub_name}-pipeline-${var.env}"
  role_arn = var.iam_code_pipeline_arn
  pipeline_type = "V2"


  // Code Pipeline Only S3 Bucket
  artifact_store {
    location = var.s3.bucket_name // Bucket Name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name      = "Source"
      category  = "Source"
      owner     = "AWS"
      region    = var.aws_config.region
      provider  = "CodeStarSourceConnection"
      namespace = "SourceVariables"
      run_order = 1
      version   = 1

      input_artifacts  = []
      output_artifacts = ["SourceArtifact"]

      configuration = {
        BranchName           = var.env
        ConnectionArn        = data.aws_codestarconnections_connection.this.arn
        FullRepositoryId     = "${var.repo_owner}/${var.project.repo_name}"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      category  = "Build"
      name      = "Build"
      namespace = "BuildVariables"

      provider  = "CodeBuild"
      owner     = "AWS"
      region    = var.aws_config.region
      run_order = 1 // 작업 실행 순서
      version   = "1"

      configuration = {
        ProjectName = "${var.name}-${var.project.sub_name}-codebuild-${var.env}"
      }

      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
    }
  }

  stage {
    name = "Deploy"

    action {
      category  = "Deploy"
      name      = "Deploy"
      namespace = "DeployVariables"

      provider  = "ECS"
      owner     = "AWS"
      region    = var.aws_config.region
      run_order = 1
      version   = "1"

      configuration = {
        ClusterName = var.ecs.cluster_name
        ServiceName = var.ecs.service_name
      }

      input_artifacts  = ["BuildArtifact"]
      output_artifacts = []
    }
  }

  tags = {
    name = "${var.name}-${var.project.sub_name}-pipeline-${var.env}"
    env  = var.env
  }
}
