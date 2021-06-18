# NOTE: usage of provider config in the module makes it incompatible with for_each, count, and depends_on
# Details available here: https://www.terraform.io/docs/language/modules/develop/providers.html

provider "grafana" {
  url  = "https://${local.grafana_endpoint}"
  auth = "${var.grafana_username}:${var.grafana_password}"
}