variable "project_name" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "service_role_arn" {
  description = "IAM role ARN for CodeBuild"
  type        = string
}

variable "github_repo_url" {
  description = "GitHub repository URL"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL to push image"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
