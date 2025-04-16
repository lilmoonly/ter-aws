variable "project_name" {
  description = "Name prefix for resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the Bastion host"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for the Bastion host"
  type        = string
}

variable "bastion_key_name" {
  description = "SSH key name for bastion host"
  type        = string
}

variable "bastion_allowed_ip" {
  description = "CIDR for accessing bastion (your public IP)"
  type        = string
}
