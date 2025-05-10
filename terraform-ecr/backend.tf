terraform {
  backend "s3" {
    bucket = "forgejo-terraform-state-bucket-s3"
    key    = "terraform-ecr/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraform-locks"
  }
}
