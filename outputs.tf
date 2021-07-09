output "postfix" {
  description = "Cluster ID / Postfix of Thanos deployment"
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
