include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/nomad-job"
}

inputs = {
  jobspec_content = <<EOT
job "nginx-web" {
  datacenters = ["dc1"]
  type        = "service"

  group "web" {
    count = 3

    network {
      port "http" {
        static = 8080
        to     = 80
      }
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "nginx:alpine"
        ports = ["http"]
      }

      resources {
        cpu    = 500
        memory = 256
      }

      service {
        name = "nginx-web"
        port = "http"

        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
EOT

  detach = false

  timeouts = {
    create = "10m"
    update = "10m"
  }
}
