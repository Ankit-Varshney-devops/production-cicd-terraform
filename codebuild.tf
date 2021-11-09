data "template_file" "buildspec" {
  template = "${file("buildspec.yml")}"
}

resource "aws_codebuild_project" "code_build" {
  badge_enabled  = false
  name           = "${var.app_name}-${var.env_type}-codebuild"
  service_role   = aws_iam_role.example.arn

  artifacts {
    encryption_disabled    = false
    name                   = "${var.app_name}-${var.env_type}-codebuild"
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"

    dynamic "environment_variable" {
      for_each = var.env_vars
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }

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
    buildspec           = data.template_file.buildspec.rendered
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }
}