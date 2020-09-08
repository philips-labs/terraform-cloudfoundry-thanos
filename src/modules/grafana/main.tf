data "cloudfoundry_org" "org" {
  name = var.cf_org
}
data "cloudfoundry_space" "space" {
  org  = data.cloudfoundry_org.org.id
  name = var.cf_space
}

data "cloudfoundry_service" "rds" {
  name = "hsdp-rds"
}

data "cloudfoundry_domain" "domain" {
  name = var.cf_domain
}

resource "cloudfoundry_app" "grafana" {
  name         = "grafana"
  space        = data.cloudfoundry_space.space.id
  memory       = 512
  disk_quota   = 2048
  docker_image = var.grafana_image

  routes {
    route = cloudfoundry_route.grafana.id
  }
}

resource "cloudfoundry_route" "grafana" {
  domain   = data.cloudfoundry_domain.domain.id
  space    = data.cloudfoundry_space.space.id
  hostname = "grafana-${var.name_postfix}"
}

resource "cloudfoundry_network_policy" "grafana" {
  dynamic "policy" {
    for_each = [for p in var.network_policies : {
      destination_app = p.destination_app
      port = p.port
      protocol = p.protocol
    }]
    content {
      source_app      = cloudfoundry_app.grafana.id
      destination_app = policy.value.destination_app
      protocol        = policy.value.protocol == "" ? "tcp" : policy.value.protocol
      port            = policy.value.port
    }
  }
}