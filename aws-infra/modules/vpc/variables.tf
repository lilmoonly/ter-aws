// VPC Module Variables - variables.tf

variable "project_name" {
  description = "Project name prefix for resource naming"
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
  default     = [] // You must provide this in terraform.tfvars or via -var flag
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
    Owner       = "team"
  }
}
