output "weather_api_url" {
  description = "HTTPie command to access weather API"
  value       = "http  ${local.external_loadbalancer}:8080/weather?city=melbourne 'Host: localhost' 'Authorization: Bearer '"
}
output "helloworld_api_url" {
  description = "HTTPie command to access helloworld API"
  value       = "http  ${local.external_loadbalancer}:8080/helloworld 'Host: localhost' 'Authorization: Bearer '"
}
output "grafana_dashboar_url" {
  description = "URL for Grafana Dashboard "
  value       = "http://${local.grafana_dashboard_url}:3000"
}

