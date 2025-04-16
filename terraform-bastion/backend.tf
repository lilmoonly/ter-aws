terraform {
  backend "s3" {
    bucket         = "forgejo-terraform-state"
    key            = "terraform-bastion/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
