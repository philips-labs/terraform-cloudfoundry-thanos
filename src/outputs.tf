output "cluster_id" {
  description = "Cluster ID of Tasy POC"
  value       = random_id.id.hex
}
