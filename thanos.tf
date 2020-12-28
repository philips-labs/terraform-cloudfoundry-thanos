resource "cloudfoundry_app" "thanos" {
  name         = "thanos"
  space        = cloudfoundry_space.space.id
  memory       = 512
  disk_quota   = 2048
  docker_image = var.thanos_image
  docker_credentials = {
    username = var.docker_username
    password = var.docker_password
  }
  environment = var.environment

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
  hostname = "thanos-${local.postfix_name}"

  depends_on = [cloudfoundry_space_users.users]
}

resource "cloudfoundry_route" "thanos_internal" {
  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = cloudfoundry_space.space.id
  hostname = "thanos-${local.postfix_name}"

  depends_on = [cloudfoundry_space_users.users]
}
