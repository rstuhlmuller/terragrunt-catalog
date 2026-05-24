include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/nomad-variable"
}

inputs = {
  path      = "myapp/production/config"
  namespace = "production"

  items = {
    # Database configuration
    db_host      = "postgres.production.internal"
    db_port      = "5432"
    db_name      = "myapp_prod"
    db_max_conns = "50"

    # API configuration
    api_base_url    = "https://api.example.com"
    api_timeout     = "30"
    api_retry_count = "3"

    # Application settings
    log_level   = "info"
    debug_mode  = "false"
    max_workers = "10"
    cache_ttl   = "3600"

    # Feature flags
    feature_new_ui   = "enabled"
    feature_beta_api = "disabled"
  }
}
