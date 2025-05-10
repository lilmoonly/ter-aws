terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "forgejo-terraform-state-bucket-s3"
    key    = "terraform-codebuild/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket = "forgejo-terraform-state-bucket-s3"
    key    = "terraform-ecr/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "codebuild_iam" {
  source = "./modules/iam/codebuild"
}

module "codebuild_project" {
  source             = "./modules/codebuild"
  project_name       = "forgejo-codebuild"
  service_role_arn   = module.codebuild_iam.codebuild_role_arn
  github_repo_url    = "https://github.com/lilmoonly/Forgejo-Docker-Kubernetes"
  ecr_repository_url = data.terraform_remote_state.ecr.outputs.repository_url

  tags = {
    Project = "Forgejo"
  }
}
