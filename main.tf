#data "external" "example" {
#  program = ["bash", "${path.module}/runme.sh"]
#}

resource "null_resource" "local_install" {
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/provision.sh"
  }
}

provider "kubernetes" {}

resource "kubernetes_replication_controller" "example" {
  depends_on = ["null_resource.local_install"]

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

#output "run" {
#  value = "${data.external.example.result.run}"
#}

