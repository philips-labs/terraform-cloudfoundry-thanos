locals {
  thanos_routes = var.thanos_public_endpoints ? [cloudfoundry_route.thanos.id, cloudfoundry_route.thanos_internal.id] : [cloudfoundry_route.thanos_internal.id]
  postfix       = var.name_postfix != "" ? var.name_postfix : random_id.id.hex
  prometheus_config = templatefile("${path.module}/templates/prometheus.yml", {
    alertmanagers = var.alertmanagers_endpoints
  })
}

resource "random_id" "id" {
  byte_length = 4
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
  command = "echo $PROMETHEUS_CONFIG_BASE64|base64 -d > /sidecars/etc/prometheus.default.yml && supervisord --nodaemon --configuration /etc/supervisord.conf"
  environment = merge({
    FILESD_URL                         = var.thanos_file_sd_url
    ENABLE_CF_EXPORTER                 = var.enable_cf_exporter
    PROMETHEUS_TARGETS                 = base64encode(var.thanos_extra_config)
    PROMETHEUS_CONFIG_BASE64           = base64encode(local.prometheus_config)
    THANOS_STORAGE_TSDB_RETENTION_TIME = var.thanos_storage_tsdb_retention_time
    USERNAME                           = var.cf_functional_account.username
    PASSWORD                           = var.cf_functional_account.password
    API_ENDPOINT                       = var.cf_functional_account.api_endpoint
    VARIANT_API_ENDPOINT               = var.cf_functional_account.api_endpoint
    VARIANT_USERNAME                   = var.cf_functional_account.username
    VARIANT_PASSWORD                   = var.cf_functional_account.password
    VARIANT_INTERNAL_DOMAIN_ID         = data.cloudfoundry_domain.apps_internal_domain.id
    VARIANT_PROMETHEUS_CONFIG          = "/sidecars/etc/prometheus.yml"
    VARIANT_TENANTS                    = join(",", var.tenants)
    VARIANT_SPACES                     = join(",", var.spaces)
    VARIANT_RELOAD                     = "true"
    S3_BUCKET                          = cloudfoundry_service_key.s3.credentials["bucket"]
    S3_ENDPOINT                        = cloudfoundry_service_key.s3.credentials["endpoint"]
    S3_API_KEY                         = cloudfoundry_service_key.s3.credentials["api_key"]
    S3_SECRET_KEY                      = cloudfoundry_service_key.s3.credentials["secret_key"]
    S3_URI                             = cloudfoundry_service_key.s3.credentials["uri"]
    },
  var.environment)


  dynamic "routes" {
    for_each = local.thanos_routes
    content {
      route = routes.value
    }
  }

  dynamic "service_binding" {
    for_each = var.thanos_service_bindings

    content {
      service_instance = service_binding.value.service_instance
    }
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
