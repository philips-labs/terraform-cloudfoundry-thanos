locals {
  thanos_routes = var.thanos_public_endpoints ? [cloudfoundry_route.thanos.id, cloudfoundry_route.thanos_internal.id] : [cloudfoundry_route.thanos_internal.id]
  postfix       = var.name_postfix != "" ? var.name_postfix : random_id.id.hex
}

resource "random_id" "id" {
  byte_length = 8
}

resource "random_password" "password" {
  length = 16
}

resource "cloudfoundry_app" "thanos" {
  name         = "tf-thanos-${local.postfix}"
  space        = var.cf_space_id
  memory       = var.thanos_memory
  disk_quota   = var.thanos_disk_quota
  docker_image = var.thanos_image
  docker_credentials = {
    username = var.docker_username
    password = var.docker_password
  }
  environment = merge({
    FILESD_URL                 = var.thanos_file_sd_url
    ENABLE_CF_EXPORTER         = var.enable_cf_exporter
    PROMETHEUS_TARGETS         = base64encode(var.thanos_extra_config)
    USERNAME                   = var.cf_exporter_config.username
    PASSWORD                   = var.cf_exporter_config.password
    API_ENDPOINT               = var.cf_exporter_config.api_endpoint
    VARIANT_API_ENDPOINT       = var.cf_exporter_config.api_endpoint
    VARIANT_USERNAME           = var.cf_exporter_config.username
    VARIANT_PASSWORD           = var.cf_exporter_config.password
    VARIANT_INTERNAL_DOMAIN_ID = data.cloudfoundry_domain.apps_internal_domain.id
    VARIANT_PROMETHEUS_CONFIG  = "/sidecars/etc/prometheus.yml"
    PG_EXPORTERS               = join(",", [module.grafana.grafana_database_metrics_endpoint])
  }, var.environment)

  dynamic "routes" {
    for_each = local.thanos_routes
    content {
      route = routes.value
    }
  }
  service_binding {
    service_instance = cloudfoundry_service_instance.s3.id
  }
}

resource "cloudfoundry_route" "thanos" {
  domain   = data.cloudfoundry_domain.app_domain.id
  space    = var.cf_space_id
  hostname = "thanos-${local.postfix}"
}

resource "cloudfoundry_route" "thanos_internal" {
  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = var.cf_space_id
  hostname = "thanos-${local.postfix}"
}
