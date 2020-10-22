output "cluster_id" {
  description = "Cluster ID of Tasy POC"
  value       = random_id.id.hex
}

output "thanos_query_endpoint" {
  description = "URL of Thanos deployment"
  value       = cloudfoundry_route.thanos_query.endpoint
}

output "grafana_endpoint" {
  description = "URL of Grafana deployment (optional)"
  value       = join("", module.grafana.*.grafana_endpoint)
}
