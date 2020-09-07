output "cluster_id" {
  description = "Cluster ID of Tasy POC"
  value       = random_id.id.hex
}

output "thanos_url" {
  description = "URL of Thanos deployment"
  value       = cloudfoundry_route.thanos.endpoint
}
