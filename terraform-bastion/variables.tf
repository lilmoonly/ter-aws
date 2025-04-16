variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "bastion_key_name" {
  description = "SSH key name for bastion"
  type        = string
}

variable "bastion_allowed_ip" {
  description = "CIDR for accessing bastion (your public IP)"
  type        = string
}
