resource "aws_codebuild_project" "this" {
  name          = var.project_name
  description   = "Build Forgejo Docker image and push to ECR"
  service_role  = var.service_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "ECR_REPO"
      value = var.ecr_repository_url
    }
  }

  source {
    type            = "GITHUB"
    location        = var.github_repo_url
    git_clone_depth = 1
  }

  source_version = "main"

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  tags = var.tags
}
