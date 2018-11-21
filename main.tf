data "external" "example" {
  program = ["bash", "${path.module}/runme.sh"]
}

provider "kubernetes" {}

resource "kubernetes_replication_controller" "example" {
  metadata {
    name = "terraform-example"

    labels {
      test = "MyExampleApp"
    }
  }

  spec {
    selector {
      test = "MyExampleApp"
    }

    template {
      container {
        image = "nginx:1.7.8"
        name  = "example"

        resources {
          limits {
            cpu    = "0.5"
            memory = "512Mi"
          }

          requests {
            cpu    = "250m"
            memory = "50Mi"
          }
        }
      }
    }
  }
}

output "run" {
  value = "${data.external.example.result.run}"
}
