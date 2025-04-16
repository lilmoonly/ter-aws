variable "db_password" {
  description = "Password for Forgejo DB user"
  type        = string
  sensitive   = true
}

variable "forgejo_secret_key" {
  description = "Secret key for Forgejo app"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name for Forgejo"
  type        = string
}
