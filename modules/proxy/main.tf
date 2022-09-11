resource "random_password" "proxy_password" {
  length  = 32
  special = false
}

resource "random_password" "proxy_username" {
  length  = 20
  special = false
}

resource "random_password" "proxy_password_salt" {
  length = 8
}


resource "htpasswd_password" "hash" {
  password = random_password.proxy_password.result
  salt     = random_password.proxy_password_salt.result
}

resource "cloudfoundry_app" "proxy" {
  name         = "tf-proxy-${var.name_postfix}"
  space        = var.cf_space_id
  memory       = 128
  disk_quota   = 512
  docker_image = var.caddy_image
  docker_credentials = {
    username = var.docker_username
    password = var.docker_password
  }

  environment = merge({
    CADDYFILE_BASE64 = base64encode(templatefile("${path.module}/templates/Caddyfile", {
      upstream_url = "http://${var.dest_internal_endpoint}:${var.dest_app_port}"
      username     = random_password.proxy_username.result
      password     = base64encode(htpasswd_password.hash.bcrypt)
    }))
  }, {})

  command           = "echo $CADDYFILE_BASE64 | base64 -d > /etc/caddy/Caddyfile && cat /etc/caddy/Caddyfile && caddy run -config /etc/caddy/Caddyfile"
  health_check_type = "process"

  //noinspection HCLUnknownBlockType
  routes {
    route = cloudfoundry_route.proxy.id
  }
}

resource "cloudfoundry_route" "proxy" {
  domain   = data.cloudfoundry_domain.domain.id
  space    = var.cf_space_id
  hostname = "tf-proxy-${var.name_postfix}"
}

resource "cloudfoundry_network_policy" "proxy" {

  policy {
    source_app      = cloudfoundry_app.proxy.id
    destination_app = var.dest_app_id
    protocol        = "tcp"
    port            = var.dest_app_port
  }
}
