resource "cloudfoundry_app" "thanos_store" {
  name         = "tf-thanos-store-${local.postfix}"
  space        = var.cf_space_id
  memory       = var.thanos_store_memory
  disk_quota   = var.thanos_store_disk_quota
  docker_image = var.thanos_store_image
  docker_credentials = {
    username = var.docker_username
    password = var.docker_password
  }
  environment = merge(
    {
      S3_BUCKET     = cloudfoundry_service_key.s3.credentials["bucket"]
      S3_ENDPOINT   = cloudfoundry_service_key.s3.credentials["endpoint"]
      S3_API_KEY    = cloudfoundry_service_key.s3.credentials["api_key"]
      S3_SECRET_KEY = cloudfoundry_service_key.s3.credentials["secret_key"]
      S3_URI        = cloudfoundry_service_key.s3.credentials["uri"]
    },
    var.environment
  )
  command = "/sidecars/bin/thanos_s3_sk.sh store --grpc-address=0.0.0.0:19090 --http-address=0.0.0.0:9090 --data-dir=/prometheus --index-cache-size=500MB --chunk-pool-size=500MB --objstore.config-file=/sidecars/etc/bucket_config.yaml"
  routes {
    route = cloudfoundry_route.thanos_store_internal.id
  }
  dynamic "service_binding" {
    for_each = var.thanos_store_service_bindings

    content {
      service_instance = service_binding.value.service_instance
    }
  }
}

resource "cloudfoundry_route" "thanos_store_internal" {
  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = var.cf_space_id
  hostname = "thanos-store-${local.postfix}"
}

resource "cloudfoundry_network_policy" "thanos_store" {
  policy {
    source_app      = cloudfoundry_app.thanos_query.id
    destination_app = cloudfoundry_app.thanos_store.id
    port            = "10901"
  }
}
