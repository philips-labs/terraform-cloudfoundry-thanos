resource "random_id" "id" {
  byte_length = 8
}

resource "random_password" "password" {
  length = 16
}

data "cloudfoundry_org" "org" {
  name = var.org_name
}

data "cloudfoundry_user" "user" {
  name   = var.user
  org_id = data.cloudfoundry_org.org.id
}

resource "cloudfoundry_space" "space" {
  name = "prometheus-thanos-${random_id.id.hex}"
  org  = data.cloudfoundry_org.org.id
}

resource "cloudfoundry_app" "prometheus_thanos" {
  name         = "prometheus-thanos"
  space        = cloudfoundry_space.space.id
  memory       = 64
  disk_quota   = 2048
  docker_image = var.prometheus_thanos_image
  routes {
    route = cloudfoundry_route.prometheus_thanos.id
  }
  service_binding {
    service_instance = cloudfoundry_service_instance.s3.id
  }

}

resource "cloudfoundry_route" "prometheus_thanos" {
  domain   = data.cloudfoundry_domain.app_domain.id
  space    = cloudfoundry_space.space.id
  hostname = "prometheus-${random_id.id.hex}"

  depends_on = [cloudfoundry_space_users.users]
}

resource "cloudfoundry_space_users" "users" {
  space      = cloudfoundry_space.space.id
  managers   = [data.cloudfoundry_user.user.id]
  developers = [data.cloudfoundry_user.user.id]
  auditors   = [data.cloudfoundry_user.user.id]
}

resource "cloudfoundry_service_instance" "s3" {
  name         = "s3"
  space        = cloudfoundry_space.space.id
  service_plan = data.cloudfoundry_service.s3.service_plans["US Standard"]

  depends_on = [cloudfoundry_space_users.users]
}

resource "cloudfoundry_service_instance" "metrics" {
  name         = "metrics"
  space        = cloudfoundry_space.space.id
  service_plan = data.cloudfoundry_service.metrics.service_plans["metrics"]
}

data "cloudfoundry_domain" "app_domain" {
  name = var.app_domain
}

data "cloudfoundry_service" "s3" {
  name = "hsdp-s3"
}

data "cloudfoundry_service" "metrics" {
  name = "hsdp-metrics"
}
