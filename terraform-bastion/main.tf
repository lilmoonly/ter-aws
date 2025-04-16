terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# Підтягуємо стейт із основного aws-infra
#data "terraform_remote_state" "network" {
#  backend = "local"
#  config = {
#    path = "../aws-infra/terraform.tfstate"
#  }
#}

module "bastion" {
  source             = "./modules/bastion"
  project_name       = var.project_name
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_id   = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  bastion_key_name   = var.bastion_key_name
  bastion_allowed_ip = var.bastion_allowed_ip
}
