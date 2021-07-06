variable "cf_org_name" {
  description = "Cloudfoundry ORG name to use for reverse proxy"
  type        = string
}

variable "cf_space_id" {
  description = "Cloudfoundry SPACE id to use for deploying all Thanos components."
  type        = string
}

variable "name_postfix" {
  type        = string
  description = "The postfix string to append to the space, hostname, etc. Prevents namespace clashes"
  default     = ""
}

variable "thanos_image" {
  description = "Image to use for Thanos app. Use a v* tagged version to prevent automatic updates"
  default     = "philipslabs/cf-thanos:v3.0.0"
  type        = string
}

variable "thanos_query_image" {
  description = "Image to use for Thanos query. Use a v* tagged version to prevent automatic updates"
  default     = "philipslabs/cf-thanos:v3.0.0"
  type        = string
}

variable "thanos_store_image" {
  description = "Image to use for Thanos store. Use a v* tagged version to prevent automatic updates"
  default     = "philipslabs/cf-thanos:v3.0.0"
  type        = string
}

variable "thanos_public_endpoints" {
  description = "Make Thanos public endpoint"
  type        = bool
  default     = false
}

variable "grafana_username" {
  description = "Grafana username"
  type        = string
  default     = "admin"
}

variable "grafana_password" {
  description = "Grafana password"
  type        = string
}

variable "grafana_image" {
  description = "Image to use for Grafana"
  default     = "grafana/grafana:latest"
  type        = string
}

variable "grafana_public_endpoints" {
  description = "Make Grafana public endpoint"
  type        = bool
  default     = true
}

variable "environment" {
  type        = map(any)
  description = "Pass environment variable to the app"
  default     = {}
}

variable "grafana_environment" {
  type        = map(any)
  description = "Pass environment variable to Grafana"
  default     = {}
}

variable "docker_username" {
  type        = string
  description = "Docker registry username"
  default     = ""
}

variable "docker_password" {
  type        = string
  description = "Docker registry password"
  default     = ""
}

variable "thanos_memory" {
  type        = number
  description = "Thanos memory"
  default     = 1024
}

variable "thanos_disk_quota" {
  type        = number
  description = "Thanos disk quota"
  default     = 5000
}

variable "thanos_store_memory" {
  type        = number
  description = "Thanos store memory"
  default     = 1024
}

variable "thanos_store_disk_quota" {
  type        = number
  description = "Thanos store disk quota"
  default     = 5000
}

variable "thanos_file_sd_url" {
  type        = string
  description = "A URL that exposes a prometheus file_sd yaml file will be periodically downloaded and used for service discovery"
  default     = ""
}

variable "enable_cf_exporter" {
  type        = bool
  description = "Enable the CloudFoundry metrics exporter and scrape it from Thanos"
  default     = false
}

variable "thanos_extra_config" {
  type        = string
  description = "Any extra yaml config that will be merged into the prometheus config at runtime. Extra targets can be added here."
  default     = ""
}

variable "tenants" {
  type        = list(string)
  description = "The list of tenants to scrape. When an app does not specify tenant then 'default' is used"
  default     = ["default"]
}

variable "cf_functional_account" {
  type = object({
    api_endpoint = string
    username     = string
    password     = string
  })
  description = "Configuration for the CloudFoundry function account. Required for variant and if enable_cf_exporter is set to true"
  default = {
    api_endpoint = ""
    username     = ""
    password     = ""
  }
}
