resource "cloudfoundry_app" "thanos_query" {
  name         = "thanos-query"
  space        = cloudfoundry_space.space.id
  memory       = 256
  disk_quota   = 2048
  docker_image = var.thanos_image
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