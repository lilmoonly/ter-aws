terraform {
  backend "s3" {
    bucket         = "forgejo-terraform-state-bucket"
    key            = "forgejo-deploy/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
  }
}
