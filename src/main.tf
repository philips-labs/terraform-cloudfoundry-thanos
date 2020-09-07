resource "random_id" "id" {
  byte_length = 8
}

resource "random_password" "password" {
  length = 16
}

data "cloudfoundry_org" "org" {
  name = var.cf_org_name
}

data "cloudfoundry_user" "user" {
  name   = var.cf_user
  org_id = data.cloudfoundry_org.org.id
}

resource "cloudfoundry_space" "space" {
  name = "thanos-${random_id.id.hex}"
  org  = data.cloudfoundry_org.org.id
}

resource "cloudfoundry_app" "thanos" {
  name         = "thanos"
  space        = cloudfoundry_space.space.id
  memory       = 512
  disk_quota   = 2048
  docker_image = var.thanos_image
  routes {
    route = cloudfoundry_route.thanos.id
  }
  routes {
    route = cloudfoundry_route.thanos_internal.id
  }
  service_binding {
    service_instance = cloudfoundry_service_instance.s3.id
  }

}

resource "cloudfoundry_route" "thanos" {
  domain   = data.cloudfoundry_domain.app_domain.id
  space    = cloudfoundry_space.space.id
  hostname = "thanos-${random_id.id.hex}"

  depends_on = [cloudfoundry_space_users.users]
}

resource "cloudfoundry_route" "thanos_internal" {
  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = cloudfoundry_space.space.id
  hostname = "thanos-${random_id.id.hex}"

  depends_on = [cloudfoundry_space_users.users]
}

resource "cloudfoundry_app" "thanos_query" {
  name         = "thanos-query"
  space        = cloudfoundry_space.space.id
  memory       = 256
  disk_quota   = 2048
  docker_image = var.thanos_image
  routes {
    route = cloudfoundry_route.thanos_query.id
  }
  routes {
    route = cloudfoundry_route.thanos_query_internal.id
  }
}

resource "cloudfoundry_route" "thanos_query" {
  domain   = data.cloudfoundry_domain.app_domain.id
  space    = cloudfoundry_space.space.id
  hostname = "thanos-query-${random_id.id.hex}"

  depends_on = [cloudfoundry_space_users.users]
}

resource "cloudfoundry_route" "thanos_query_internal" {
  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = cloudfoundry_space.space.id
  hostname = "thanos-query-${random_id.id.hex}"

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

  depends_on = [cloudfoundry_space_users.users]
}

data "cloudfoundry_domain" "app_domain" {
  name = var.cf_app_domain
}

data "cloudfoundry_domain" "apps_internal_domain" {
  name = "apps.internal"
}

data "cloudfoundry_service" "s3" {
  name = "hsdp-s3"
}

data "cloudfoundry_service" "metrics" {
  name = "hsdp-metrics"
}
