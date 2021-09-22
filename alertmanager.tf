locals {
  alertmanager_routes = [cloudfoundry_route.alertmanager_internal.id]

  webhook_url = var.teams_incoming_webhook_url != "" ? "http://${cloudfoundry_route.prometheusmsteams_internal[0].endpoint}:2000/alertmanager" : "http://localhost:5001"

  alertmanager_config = var.alertmanager_config == "" ? templatefile("${path.module}/templates/alertmanager.yml", { url = local.webhook_url }) : var.alertmanager_config
}

resource "cloudfoundry_app" "prometheusmsteams" {
  count        = var.teams_incoming_webhook_url != "" ? 1 : 0
  name         = "tf-prometheusmsteams-${local.postfix}"
  space        = var.cf_space_id
  docker_image = "quay.io/prometheusmsteams/prometheus-msteams"
  memory       = 64
  disk_quota   = 1024
  environment = {
    TEAMS_REQUEST_URI          = "alertmanager"
    TEAMS_INCOMING_WEBHOOK_URL = var.teams_incoming_webhook_url
  }

  routes {
    route = cloudfoundry_route.prometheusmsteams_internal[count.index].id
  }
}

resource "cloudfoundry_route" "prometheusmsteams_internal" {
  count    = var.teams_incoming_webhook_url != "" ? 1 : 0
  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = var.cf_space_id
  hostname = "tf-prometheusmsteams-${local.postfix}"
}

resource "cloudfoundry_app" "alertmanager" {
  name         = "tf-alertmanager-${local.postfix}"
  space        = var.cf_space_id
  memory       = 512
  disk_quota   = 2048
  docker_image = var.alertmanager_image
  docker_credentials = {
    username = var.docker_username
    password = var.docker_password
  }
  environment = merge({
    ALERTMANAGER_CONFIG_BASE64 = base64encode(local.alertmanager_config)
  }, var.environment)
  command = "echo $ALERTMANAGER_CONFIG_BASE64 | base64 -d > /etc/alertmanager/alertmanager.yml && /bin/alertmanager --config.file=/etc/alertmanager/alertmanager.yml --storage.path=/alertmanager --web.route-prefix=/alertmanager"

  dynamic "routes" {
    for_each = local.alertmanager_routes
    content {
      route = routes.value
    }
  }
}

resource "cloudfoundry_route" "alertmanager_internal" {
  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = var.cf_space_id
  hostname = "tf-alertmanager-${local.postfix}"
}

resource "cloudfoundry_network_policy" "prometheusmsteams" {
  count = var.teams_incoming_webhook_url != "" ? 1 : 0

  policy {
    source_app      = cloudfoundry_app.alertmanager.id
    destination_app = cloudfoundry_app.prometheusmsteams[count.index].id
    protocol        = "tcp"
    port            = "2000"
  }
}

resource "cloudfoundry_network_policy" "alertmanager" {
  policy {
    source_app      = cloudfoundry_app.thanos.id
    destination_app = cloudfoundry_app.alertmanager.id
    protocol        = "tcp"
    port            = "9093"
  }
}
