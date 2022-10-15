resource "cloudfoundry_app" "hsdp_metrics_exporter" {
  count = var.enable_hsdp_metrics_exporter ? 1 : 0

  name         = "tf-hsdp-metrics-exporter-${local.postfix}"
  space        = var.cf_space_id
  memory       = var.hsdp_metrics_exporter.memory
  disk_quota   = var.hsdp_metrics_exporter.disk_quota
  docker_image = var.hsdp_metrics_exporter.image
  timeout      = var.hsdp_metrics_exporter.timeout

  docker_credentials = {
    username = var.hsdp_metrics_exporter.docker_username
    password = var.hsdp_metrics_exporter.docker_password
  }
  environment = {
    UAA_USERNAME = var.cf_functional_account.username
    UAA_PASSWORD = var.cf_functional_account.password
    HSDP_REGION  = var.hsdp_metrics_exporter.region
  }

  routes {
    route = cloudfoundry_route.hsdp_metrics_exporter_internal[0].id
  }

  labels = {
    "variant.tva/exporter" = true
  }

  annotations = {
    "prometheus.exporter.port" = "8889"
    "prometheus.exporter.path" = "/metrics"
  }
}

resource "cloudfoundry_route" "hsdp_metrics_exporter_internal" {
  count = var.enable_hsdp_metrics_exporter ? 1 : 0

  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = var.cf_space_id
  hostname = "hsdp-metrics-exporter-${local.postfix}"
}
