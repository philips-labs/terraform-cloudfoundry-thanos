variable "dest_app_id" {
  type = string
}

variable "dest_app_port" {
  type    = string
  default = "9090"
}

variable "dest_internal_endpoint" {
  type = string
}


variable "cf_domain" {
  type        = string
  description = "The CF domain name to use"
}

variable "cf_space_id" {
  type        = string
  description = "The CF Space to deploy in"
}

variable "name_postfix" {
  type        = string
  description = "The postfix string to append to the hostname, prevents namespace clashes"
}

variable "memory" {
  type        = number
  description = "The amount of RAM to allocate for Caddy (MB)"
  default     = 128
}

variable "disk" {
  type        = number
  description = "The amount of Disk space to allocate for Grafana Loki (MB)"
  default     = 1024
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

variable "caddy_image" {
  type        = string
  description = "Caddy server image to use"
  default     = "library/caddy:2.5.0"
}
