resource "cloudfoundry_app" "cfpaasexporter" {
  count = var.enable_cf_exporter ? 1 : 0

  name         = "tf-cfpaasexporter-${local.postfix}"
  space        = var.cf_space_id
  memory       = var.cf_paas_exporter_memory
  disk_quota   = var.cf_paas_exporter_disk_quota
  docker_image = var.cf_paas_exporter_image
  docker_credentials = {
    username = var.docker_username
    password = var.docker_password
  }
  environment = {
    USERNAME     = var.cf_functional_account.username
    PASSWORD     = var.cf_functional_account.password
    API_ENDPOINT = var.cf_functional_account.api_endpoint
  }

  labels = {
    "variant.tva/exporter" = true
  }

  annotations = {
    "prometheus.exporter.port" = "18080"
    "prometheus.exporter.path" = "/metrics"
  }
}

resource "cloudfoundry_route" "cfpaasexporter_internal" {
  count = var.enable_cf_exporter ? 1 : 0

  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = var.cf_space_id
  hostname = "cfpaasexporter-${local.postfix}"
}

resource "cloudfoundry_network_policy" "cfpaasexporter" {
  count = var.enable_cf_exporter ? 1 : 0


  policy {
    source_app      = cloudfoundry_app.thanos.id
    destination_app = cloudfoundry_app.cfpaas_exporter.id
    port            = "18080"
  }
}
