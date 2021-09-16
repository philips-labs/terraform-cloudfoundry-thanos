locals {
  thanos_query_routes = var.thanos_public_endpoints ? [cloudfoundry_route.thanos_query.id, cloudfoundry_route.thanos_query_internal.id] : [cloudfoundry_route.thanos_query_internal.id]
}

resource "cloudfoundry_app" "thanos_query" {
  name         = "tf-thanos-query-${local.postfix}"
  space        = var.cf_space_id
  memory       = 256
  disk_quota   = 2048
  docker_image = var.thanos_query_image
  docker_credentials = {
    username = var.docker_username
    password = var.docker_password
  }
  environment = var.environment
  command     = "/sidecars/bin/thanos query --grpc-address=0.0.0.0:10901 --http-address=0.0.0.0:9090 --store=${cloudfoundry_route.thanos_internal.endpoint}:19090 --store=${cloudfoundry_route.thanos_store_internal.endpoint}:19090"

  dynamic "routes" {
    for_each = local.thanos_query_routes
    content {
      route = routes.value
    }
  }
}

resource "cloudfoundry_route" "thanos_query" {
  domain   = data.cloudfoundry_domain.app_domain.id
  space    = var.cf_space_id
  hostname = "thanos-query-${local.postfix}"
}

resource "cloudfoundry_route" "thanos_query_internal" {
  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = var.cf_space_id
  hostname = "thanos-query-${local.postfix}"
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
