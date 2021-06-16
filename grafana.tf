module "grafana" {
  source  = "philips-labs/grafana/cloudfoundry"
  version = "0.6.0"

  count           = var.enable_grafana ? 1 : 0
  enable_postgres = var.enable_grafana_postgres
  grafana_image   = var.grafana_image
  cf_space        = local.space_name
  cf_org          = data.cloudfoundry_org.org.name
  cf_domain       = var.grafana_public_endpoints ? data.cloudfoundry_domain.app_domain.name : data.cloudfoundry_domain.apps_internal_domain.name
  name_postfix    = local.postfix_name
  environment     = var.grafana_environment
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

  depends_on = [cloudfoundry_space_users.users]
}
