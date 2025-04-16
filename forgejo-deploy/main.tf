provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket         = "forgejo-terraform-state-bucket"
    key            = "aws-infra/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
  }
}

resource "helm_release" "forgejo" {
  name      = "forgejo"
  chart     = "../forgejo-chart"
  namespace = "default"

  set {
    name  = "forgejo.config.dbHost"
    value = data.terraform_remote_state.infra.outputs.rds_endpoint
  }


  set {
    name  = "forgejo.credentials.dbUser"
    value = "forgejo"
  }

  set {
    name  = "forgejo.credentials.dbPass"
    value = var.db_password
  }

  set_sensitive {
    name  = "forgejo.credentials.secretKey"
    value = var.forgejo_secret_key
  }

  set {
    name  = "forgejo.config.dbName"
    value = var.db_name
  }

  set {
    name  = "forgejo.config.dbHost"
    value = data.terraform_remote_state.infra.outputs.rds_host
  }

  set {
    name  = "forgejo.config.dbPort"
    value = data.terraform_remote_state.infra.outputs.rds_port
  }

}
