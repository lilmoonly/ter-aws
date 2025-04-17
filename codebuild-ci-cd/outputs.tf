output "codebuild_project_name" {
  value = module.codebuild_project.codebuild_project_name
}

output "codebuild_project_arn" {
  value = module.codebuild_project.codebuild_project_arn
}

output "codebuild_role_arn" {
  value = module.codebuild_iam.codebuild_role_arn
}
