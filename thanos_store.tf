resource "cloudfoundry_app" "thanos_store" {
  name         = "thanos-store"
  space        = cloudfoundry_space.space.id
  memory       = var.thanos_store_memory
  disk_quota   = var.thanos_store_disk_quota
  docker_image = var.thanos_store_image
  docker_credentials = {
    username = var.docker_username
    password = var.docker_password
  }
  environment = var.environment
  command     = "/sidecars/bin/thanos_s3.sh store --grpc-address=0.0.0.0:19090 --http-address=0.0.0.0:9090 --data-dir=/prometheus --index-cache-size=500MB --chunk-pool-size=500MB --objstore.config-file=/sidecars/etc/bucket_config.yaml"
  routes {
    route = cloudfoundry_route.thanos_store_internal.id
  }
  service_binding {
    service_instance = cloudfoundry_service_instance.s3.id
  }
}

resource "cloudfoundry_route" "thanos_store_internal" {
  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = cloudfoundry_space.space.id
  hostname = "thanos-store-${local.postfix_name}"

  depends_on = [cloudfoundry_space_users.users]
}

resource "cloudfoundry_network_policy" "thanos_store" {
  policy {
    source_app      = cloudfoundry_app.thanos_query.id
    destination_app = cloudfoundry_app.thanos_store.id
    port            = "10901"
  }
}
