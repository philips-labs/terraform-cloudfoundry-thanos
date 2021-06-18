# NOTE: usage of provider config in the module makes it incompatible with for_each, count, and depends_on
# Details available here: https://www.terraform.io/docs/language/modules/develop/providers.html
locals {
  grafana_auth = "${var.grafana_username}:${var.grafana_password}"
  grafana_url  = "https://${local.grafana_endpoint}"
}

provider "grafana" {
  url  = local.grafana_url
  auth = local.grafana_auth
}