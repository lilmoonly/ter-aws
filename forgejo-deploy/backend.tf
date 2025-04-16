terraform {
  backend "s3" {
    bucket         = "forgejo-terraform-state"
    key            = "forgejo-deploy/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
