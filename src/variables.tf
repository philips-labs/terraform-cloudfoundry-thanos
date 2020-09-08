variable "cf_org_name" {
  description = "Cloudfoundry ORG name to use for reverse proxy"
  type        = string
}

variable "cf_app_domain" {
  description = "The Cloudfoundry regular app domain to use"
  type        = string
  default     = "us-east.philips-healthsuite.com"
}

variable "cf_user" {
  description = "The Cloudfoundry user to assign rights to the app to"
  type        = string
}

variable "thanos_image" {
  description = "Image to use for Thanos app"
  default     = "loafoe/cf-thanos:0.0.9"
  type        = string
}

variable "thanos_query_image" {
  description = "Image to use for Thanos query"
  default     = "loafoe/cf-thanos:0.0.9"
  type        = string
}

variable "enable_grafana" {
  description = "Adds a Grafana deployment when enabled"
  type        = bool
  default     = false
}

variable "grafana_image" {
  description = "Image to use for Grafana"
  default     = "grafana/grafana:latest"
  type        = string
}
