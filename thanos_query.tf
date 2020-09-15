resource "cloudfoundry_app" "thanos_query" {
  name         = "thanos-query"
  space        = cloudfoundry_space.space.id
  memory       = 256
  disk_quota   = 2048
  docker_image = var.thanos_query_image
  command      = "/sidecars/bin/thanos query --grpc-address=0.0.0.0:10901 --http-address=0.0.0.0:9090 --store=${cloudfoundry_route.thanos_internal.endpoint}:19090 --store=${cloudfoundry_route.thanos_store_internal.endpoint}:19090"
  routes {
    route = cloudfoundry_route.thanos_query.id
  }
  routes {
    route = cloudfoundry_route.thanos_query_internal.id
  }
}

resource "cloudfoundry_route" "thanos_query" {
  domain   = data.cloudfoundry_domain.app_domain.id
  space    = cloudfoundry_space.space.id
  hostname = "thanos-query-${random_id.id.hex}"

  depends_on = [cloudfoundry_space_users.users]
}

resource "cloudfoundry_route" "thanos_query_internal" {
  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = cloudfoundry_space.space.id
  hostname = "thanos-query-${random_id.id.hex}"

  depends_on = [cloudfoundry_space_users.users]
}

resource "cloudfoundry_network_policy" "thanos_query" {
  policy {
    source_app      = cloudfoundry_app.thanos_query.id
    destination_app = cloudfoundry_app.thanos.id
    port            = "19090"
  }
  policy {
    source_app      = cloudfoundry_app.thanos_query.id
    destination_app = cloudfoundry_app.thanos_store.id
    port            = "19090"
  }
}
