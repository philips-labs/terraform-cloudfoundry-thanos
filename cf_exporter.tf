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

  command = "export USERNAME=${var.cf_functional_account.username};export PASSWORD=${var.cf_functional_account.password};paas-prometheus-exporter"

  environment = {
    API_ENDPOINT = var.cf_functional_account.api_endpoint
  }

  routes {
    route = cloudfoundry_route.cfpaasexporter_internal[0].id
  }

  labels = {
    "variant.tva/exporter" = true
  }

  annotations = {
    "prometheus.exporter.port" = "8080"
    "prometheus.exporter.path" = "/metrics"
  }
}

resource "cloudfoundry_route" "cfpaasexporter_internal" {
  count = var.enable_cf_exporter ? 1 : 0

  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = var.cf_space_id
  hostname = "cfpaasexporter-${local.postfix}"
}
