locals {
  grafana_endpoint = join("", module.grafana.*.grafana_endpoint)
}

output "cluster_id" {
  description = "Cluster ID of Thanos deployment"
  value       = local.postfix
}

output "thanos_space_id" {
  description = "Cloud foundry space ID of Thanos"
  value       = var.cf_space_id
}

output "thanos_query_app_id" {
  description = "App id for Thanos Query"
  value       = cloudfoundry_app.thanos_query.id
}

output "thanos_query_endpoint" {
  description = "URL of Thanos query deployment"
  value       = var.thanos_public_endpoints ? cloudfoundry_route.thanos_query.endpoint : "${cloudfoundry_route.thanos_query_internal.endpoint}:9090"
}

output "thanos_app_id" {
  description = "App id for Thanos"
  value       = cloudfoundry_app.thanos.id
}

output "thanos_endpoint" {
  description = "URL of Thanos deployment"
  value       = var.thanos_public_endpoints ? cloudfoundry_route.thanos.endpoint : "${cloudfoundry_route.thanos_internal.endpoint}:9090"
}

output "thanos_store_app_id" {
  description = "App id for Thanos Store"
  value       = cloudfoundry_app.thanos_store.id
}

output "thanos_store_endpoint" {
  description = "Internal only URL of Thanos store deployment"
  value       = "${cloudfoundry_route.thanos_store_internal.endpoint}:9090"
}

output "grafana_app_id" {
  description = "App id for Grafana"
  value       = join("", module.grafana.*.grafana_id)
}

output "grafana_endpoint" {
  description = "URL of Grafana deployment (optional)"
  value       = var.grafana_public_endpoints ? local.grafana_endpoint : "${local.grafana_endpoint}:3000"
}

output "grafana_auth" {
  description = "The Grafana auth token to use for e.g. configuring Grafana provider"
  value       = local.grafana_auth
  sensitive   = true
}

output "grafana_username" {
  description = "The Grafana username"
  value       = var.grafana_username
}

output "grafana_url" {
  description = "The Grafana URL"
  value       = local.grafana_url
}