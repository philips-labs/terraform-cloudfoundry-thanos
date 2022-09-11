module "proxy" {
  count  = var.enable_prometheus_proxy ? 1 : 0
  source = "./modules/proxy"


  dest_app_id            = cloudfoundry_app.thanos.id
  dest_internal_endpoint = cloudfoundry_route.thanos_internal.endpoint
  name_postfix           = "prometheus-${local.postfix}"
  cf_domain              = data.hsdp_config.cf.domain
  cf_space_id            = var.cf_space_id
}
