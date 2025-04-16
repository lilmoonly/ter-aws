output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "eks_cluster_endpoint" {
  description = "EKS Cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "EKS Cluster CA data"
  value       = module.eks.cluster_certificate_authority_data
}

output "eks_admin_role_arn" {
  description = "ARN of the EKS admin IAM role"
  value       = module.eks_admin.eks_admin_role_arn
}

output "rds_endpoint" {
  description = "Endpoint of the RDS PostgreSQL instance"
  value       = module.rds.db_instance_endpoint
}

output "rds_port" {
  description = "Port for the RDS PostgreSQL instance"
  value       = module.rds.db_instance_port
}

output "eks_endpoint" {
  value = module.eks.cluster_endpoint
}

