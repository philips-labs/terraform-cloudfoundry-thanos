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
  name = "thanos-${random_id.id.hex}"
  org  = data.cloudfoundry_org.org.id
}

resource "cloudfoundry_app" "prometheus" {
  name         = "prometheus"
  space        = cloudfoundry_space.space.id
  memory       = 64
  disk_quota   = 2048
  docker_image = var.prometheus_image
  environment = {
    FOO = "bar"
  }
  routes {
    route = cloudfoundry_route.prometheus.id
  }
}

resource "cloudfoundry_app" "thanos" {
  name         = "thanos"
  space        = cloudfoundry_space.space.id
  memory       = 512
  disk_quota   = 2048
  docker_image = var.thanos_image
  environment = {
    ADMIN_PASSWORD = random_password.password.result
  }
  service_binding {
    service_instance = cloudfoundry_service_instance.s3.id
  }
  routes {
    route = cloudfoundry_route.thanos.id
  }
}

resource "cloudfoundry_route" "thanos" {
  domain   = data.cloudfoundry_domain.app_domain.id
  space    = cloudfoundry_space.space.id
  hostname = "thanos-${random_id.id.hex}"

  depends_on = [cloudfoundry_space_users.users]
}


resource "cloudfoundry_route" "prometheus" {
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
