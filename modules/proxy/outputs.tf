output "proxy_username" {
  description = "The Proxy username"
  value       = random_password.proxy_username.result
}

output "proxy_password" {
  description = "The Proxy password"
  value       = random_password.proxy_password.result
  sensitive   = true
}

output "proxy_endpoint" {
  description = "The Proxy endpoint"
  value       = cloudfoundry_route.proxy.endpoint
}
