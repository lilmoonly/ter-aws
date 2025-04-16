variable "region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "forgejo"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of Availability Zones to use (e.g. ['eu-central-1a', 'eu-central-1b', 'eu-central-1c'])"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Owner       = "Bohdan"
  }
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "forgejo-eks"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS Cluster"
  type        = string
  default     = "1.29"
}

variable "db_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage for RDS (in GB)"
  type        = number
  default     = 20
}

variable "db_master_username" {
  description = "Master username for RDS"
  type        = string
}

variable "db_name" {
  description = "Name of the PostgreSQL database to create"
  type        = string
}

variable "db_master_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Deploy RDS in Multi-AZ configuration"
  type        = bool
}

variable "publicly_accessible" {
  description = "Should RDS be publicly accessible? (Not recommended for production)"
  type        = bool
}

variable "backup_retention_period" {
  description = "Backup retention period (in days)"
  type        = number
}

variable "rds_allowed_cidrs" {
  description = "List of CIDR blocks allowed to access RDS (e.g., worker nodes range or office IP)"
  type        = list(string)
}

variable "family" {
  description = "Parameter group family for the RDS engine"
  type        = string
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDRs allowed to access EKS public endpoint"
  type        = list(string)
}
