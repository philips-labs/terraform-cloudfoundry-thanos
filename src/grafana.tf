resource "cloudfoundry_app" "grafana" {
  name         = "grafana"
  space        = cloudfoundry_space.space.id
  memory       = 512
  disk_quota   = 2048
  docker_image = var.grafana_image
  routes {
    route = cloudfoundry_route.grafana.id
  }
  routes {
    route = cloudfoundry_route.grafana.id
  }
}

resource "cloudfoundry_route" "grafana" {
  domain   = data.cloudfoundry_domain.app_domain.id
  space    = cloudfoundry_space.space.id
  hostname = "grafana-${random_id.id.hex}"

  depends_on = [cloudfoundry_space_users.users]
}

resource "cloudfoundry_network_policy" "grafana_thanos" {
  policy {
    source_app      = cloudfoundry_app.grafana.id
    destination_app = cloudfoundry_app.thanos_query.id
    port            = "9090"
  }
}
