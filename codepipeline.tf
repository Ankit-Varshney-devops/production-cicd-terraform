resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "codepipeline-${var.aws_region}-${var.app_name}-${var.env_type}"
  acl    = "private"
}

resource "aws_codestarconnections_connection" "example" {
  name          = var.codestarconnections_name
  provider_type = "Bitbucket"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.app_name}-${var.env_type}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.example.arn
        FullRepositoryId = var.reponame
        BranchName       = var.repo-branch
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${var.app_name}-${var.env_type}-codebuild"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"   
      provider        = "CodeDeploy"
      input_artifacts = ["build_output"]
      version         = "1"

    configuration = {
        ApplicationName = aws_codedeploy_app.codedeploy_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.deployment_group.deployment_group_name
      }
    }
  }
}