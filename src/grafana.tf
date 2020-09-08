module "grafana" {
  source = "./modules/grafana"

  count         = var.enable_grafana ? 1 : 0
  grafana_image = var.grafana_image
  cf_space      = cloudfoundry_space.space.name
  cf_org        = data.cloudfoundry_org.org.name
  cf_domain     = data.cloudfoundry_domain.app_domain.name
  name_postfix  = random_id.id.hex
  network_policies = [
    {
      destination_app = cloudfoundry_app.thanos.id
      protocol        = "tcp"
      port            = "9090"
    }
  ]
}