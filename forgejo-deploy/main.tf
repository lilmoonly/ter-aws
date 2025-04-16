provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "forgejo" {
  name      = "forgejo"
  chart     = "../forgejo-chart"
  namespace = "default"

  set {
    name  = "forgejo.config.dbHost"
    value = data.terraform_remote_state.infra.outputs.forgejo_db_host
  }

  set {
    name  = "forgejo.config.dbPort"
    value = "5432"
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
}
