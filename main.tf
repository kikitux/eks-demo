data "external" "local_install" {
  program = ["bash", "${path.module}/scripts/data.sh"]
}

resource "null_resource" "local_install" {
  depends_on = ["data.external.local_install"]

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/null.sh"
  }

  triggers {
    timestamp = "${timestamp()}"
  }
}

resource "null_resource" "local_install_on_destroy" {
  depends_on = ["data.external.local_install"]

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/null.sh"
    when    = "destroy"
  }
}

provider "kubernetes" {}

resource "kubernetes_replication_controller" "example" {
  depends_on = ["data.external.local_install", "null_resource.local_install"]

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
