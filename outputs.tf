output "cluster_id" {
  description = "Cluster ID of Tasy POC"
  value       = local.postfix_name
}

output "thanos_query_endpoint" {
  description = "URL of Thanos deployment"
  value       = cloudfoundry_route.thanos_query.endpoint
}

output "grafana_endpoint" {
  description = "URL of Grafana deployment (optional)"
  value       = join("", module.grafana.*.grafana_endpoint)
}

output "thanos_space_id" {
  description = "Cloud foundry space ID of Thanos"
  value       = cloudfoundry_space.space.id
}

output "thanos_app_id" {
  description = "App id for Thanos"
  value = cloudfoundry_app.thanos.id
}