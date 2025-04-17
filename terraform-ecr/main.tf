provider "aws" {
  region = "eu-central-1"
}

resource "aws_ecr_repository" "forgejo" {
  name = var.repository_name

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = var.repository_name
  }
}
