locals {
  alertmanager_routes = [cloudfoundry_route.alertmanager_internal.id]
}

resource "cloudfoundry_app" "alertmanager" {
  name         = "alertmanager"
  space        = cloudfoundry_space.space.id
  memory       = 512
  disk_quota   = 2048
  docker_image = var.alertmanager_image
  docker_credentials = {
    username = var.docker_username
    password = var.docker_password
  }
  environment = var.environment

  dynamic "routes" {
    for_each = local.alertmanager_routes
    content {
      route = routes.value
    }
  }
}

resource "cloudfoundry_route" "alertmanager_internal" {
  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = cloudfoundry_space.space.id
  hostname = "alertmanager-${local.postfix_name}"

  depends_on = [cloudfoundry_space_users.users]
}

resource "cloudfoundry_network_policy" "alertmanager" {
  policy {
    source_app      = cloudfoundry_app.thanos.id
    destination_app = cloudfoundry_app.alertmanager.id
    port            = "9093"
  }
}
