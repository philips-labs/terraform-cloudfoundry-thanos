module "grafana" {
  source  = "philips-labs/grafana/cloudfoundry"
  version = "0.8.3"

  enable_postgres  = true
  grafana_image    = var.grafana_image
  grafana_username = var.grafana_username
  grafana_password = var.grafana_password
  cf_space         = local.space_name
  cf_org           = data.cloudfoundry_org.org.name
  cf_domain        = var.grafana_public_endpoints ? data.cloudfoundry_domain.app_domain.name : data.cloudfoundry_domain.apps_internal_domain.name
  name_postfix     = local.postfix
  environment      = var.grafana_environment
  network_policies = [
    {
      destination_app = cloudfoundry_app.thanos_query.id
      protocol        = "tcp"
      port            = "9090"
    },
    {
      destination_app = cloudfoundry_app.thanos_store.id
      protocol        = "tcp"
      port            = "9090"
    }
  ]
}

resource "cloudfoundry_network_policy" "grafana_database_metrics" {
  policy {
    source_app      = cloudfoundry_app.thanos.id
    destination_app = module.grafana.grafana_database_metrics_app_id
    port            = module.grafana.grafana_database_metrics_port
  }
}

resource "grafana_data_source" "thanos" {
  name        = "thanos"
  type        = "prometheus"
  url         = "${cloudfoundry_route.thanos_query_internal.endpoint}:9090"
  access_mode = "proxy"
  is_default  = true

  depends_on = [module.grafana.grafana_endpoint]
}