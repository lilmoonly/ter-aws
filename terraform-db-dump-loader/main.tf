provider "kubernetes" {
  config_path = "~/.kube/config"
}

data "terraform_remote_state" "infra" {
  backend = "s3"

  config = {
    bucket = "forgejo-terraform-state-bucket-s3"
    key    = "aws-infra/terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "kubernetes_secret" "db_dump_secret" {
  metadata {
    name = "db-dump-secret"
  }

  data = {
    db_user   = var.db_user
    db_pass   = var.db_pass
    db_host   = data.terraform_remote_state.infra.outputs.rds_endpoint
    db_name   = var.db_name
    dump_data = var.dump_data
  }

  type = "Opaque"
}

resource "kubernetes_job" "load_db_dump" {
  metadata {
    name = "load-db-dump"
  }

  spec {
    template {
      metadata {
        name = "load-db-dump"
      }

      spec {
        restart_policy = "Never"

        container {
          name  = "loader"
          image = "postgres:15"

          command = ["/bin/bash", "-c"]
          args = [
            <<-EOT
            echo "$${DUMP_DATA}" | base64 -d > /tmp/dump.sql && \
            export DB_HOST_ONLY=$$(echo "$${DB_HOST}" | cut -d ':' -f1) && \
            export DB_PORT=$$(echo "$${DB_HOST}" | cut -d ':' -f2) && \
            until pg_isready -h $$DB_HOST_ONLY -p $$DB_PORT -U $${DB_USER}; do echo 'Waiting for DB...'; sleep 3; done && \
            PGPASSWORD=$${DB_PASS} psql -h $$DB_HOST_ONLY -p $$DB_PORT -U $${DB_USER} -d $${DB_NAME} -f /tmp/dump.sql
            EOT
          ]

          env {
            name = "DB_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_dump_secret.metadata[0].name
                key  = "db_user"
              }
            }
          }

          env {
            name = "DB_PASS"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_dump_secret.metadata[0].name
                key  = "db_pass"
              }
            }
          }

          env {
            name = "DB_HOST"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_dump_secret.metadata[0].name
                key  = "db_host"
              }
            }
          }

          env {
            name = "DB_NAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_dump_secret.metadata[0].name
                key  = "db_name"
              }
            }
          }

          env {
            name = "DUMP_DATA"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_dump_secret.metadata[0].name
                key  = "dump_data"
              }
            }
          }
        }
      }
    }
  }
}
