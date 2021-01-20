locals {
  grafana_endpoint = join("", module.grafana.*.grafana_endpoint)
}
output "cluster_id" {
  description = "Cluster ID of Thanos deployment"
  value       = local.postfix_name
}

output "thanos_query_endpoint" {
  description = "URL of Thanos deployment"
  value       = var.thanos_public_endpoints ? cloudfoundry_route.thanos_query.endpoint : "${cloudfoundry_route.thanos_query_internal.endpoint}:9090"
}

output "grafana_endpoint" {
  description = "URL of Grafana deployment (optional)"
  value       = var.grafana_public_endpoints ? local.grafana_endpoint : "${local.grafana_endpoint}:3000"
}

output "thanos_space_id" {
  description = "Cloud foundry space ID of Thanos"
  value       = cloudfoundry_space.space.id
}

output "thanos_app_id" {
  description = "App id for Thanos"
  value       = cloudfoundry_app.thanos.id
}

output "grafana_app_id" {
  description = "App id for Grafana"
  value       = join("", module.grafana.*.grafana_id)
}

output "thanos_query_app_id" {
  description = "App id for Thanos Query"
  value       = cloudfoundry_app.thanos_query.id
}
