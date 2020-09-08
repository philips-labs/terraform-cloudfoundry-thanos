variable "grafana_image" {}
variable "cf_org" {}
variable "cf_space" {}
variable "cf_domain" {}
variable "name_postfix" {}
variable "network_policies" {
  type = list(object({
    destination_app = string
    protocol        = string
    port            = string
  }))
}