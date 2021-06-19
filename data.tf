data "cloudfoundry_org" "org" {
  name = var.cf_org_name
}

data "hsdp_config" "cf" {
  service = "cf"
}

data "cloudfoundry_domain" "app_domain" {
  //noinspection HILUnresolvedReference
  name = data.hsdp_config.cf.domain
}

data "cloudfoundry_domain" "apps_internal_domain" {
  name = "apps.internal"
}

data "cloudfoundry_service" "s3" {
  name = "hsdp-s3"
}