include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/nomad-namespace"
}

inputs = {
  name        = "production"
  description = "Production environment namespace with restricted capabilities"

  meta = {
    environment = "production"
    team        = "platform-engineering"
    owner       = "devops@example.com"
    cost_center = "engineering"
    compliance  = "soc2"
  }

  capabilities = {
    enabled_task_drivers = [
      "docker",
      "exec"
    ]
    disabled_task_drivers = [
      "raw_exec"
    ]
    enabled_network_modes = [
      "bridge",
      "host"
    ]
    disabled_network_modes = []
  }
}
