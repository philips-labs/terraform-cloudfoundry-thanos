variable "ldap_user" {
  description = "LDAP user to use for connections"
  type        = string
}

variable "org_name" {
  description = "Cloudfoundry ORG name to use for reverse proxy"
  type        = string
}

variable "app_domain" {
  description = "The regular app domain to use"
  type        = string
  default     = "us-east.philips-healthsuite.com"
}

variable "prometheus_thanos_image" {
  description = "Image to use for Prometheus + Thanos app"
  default     = "loafoe/prometheus-thanos:0.0.1"
  type        = string
}
