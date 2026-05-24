include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/nomad-job"
}

inputs = {
  jobspec_content = <<EOT
job "batch-processor" {
  datacenters = ["dc1"]
  type        = "batch"
  namespace   = "production"

  parameterized {
    payload       = "required"
    meta_required = ["job_id", "input_file"]
  }

  group "processor" {
    restart {
      attempts = 3
      delay    = "30s"
      interval = "5m"
      mode     = "fail"
    }

    task "process" {
      driver = "docker"

      config {
        image = "my-company/batch-processor:latest"
        args  = [
          "--input", "$${NOMAD_META_input_file}",
          "--job-id", "$${NOMAD_META_job_id}"
        ]
      }

      template {
        data = <<ENVEOF
{{ with nomadVar "myapp/production/config" }}
DB_HOST={{ .db_host }}
DB_PORT={{ .db_port }}
DB_NAME={{ .db_name }}
API_BASE_URL={{ .api_base_url }}
LOG_LEVEL={{ .log_level }}
{{ end }}
ENVEOF
        destination = "secrets/.env"
        env         = true
      }

      resources {
        cpu    = 1000
        memory = 2048
      }

      logs {
        max_files     = 5
        max_file_size = 20
      }
    }
  }
}
EOT

  detach           = false
  rerun_if_dead    = false
  purge_on_destroy = true

  timeouts = {
    create = "5m"
    update = "5m"
  }
}
