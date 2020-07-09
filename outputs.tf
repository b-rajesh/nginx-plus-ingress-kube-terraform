output "nginx_ingress_external_loadbalancer" {
  description = "The external Url to access NGiNX Plus Ingress Controller"
  value       = "http://${local.external_loadbalancer}:8080"
}
output "weather_api_url" {
  description = "Curl command to access weather API"
  value       = "curl --Header 'Host: localhost' http://${local.external_loadbalancer}:8080/weather?city=melbourne"
}
output "helloworld_api_url" {
  description = "Curl command to access helloworld API"
  value       = "curl --Header 'Host: localhost' http://${local.external_loadbalancer}:8080/helloworld"
}
output "grafana_dashboar_url" {
  description = "URL for Grafana Dashboard "
  value       = "http://${local.grafana_dashboard_url}:3000"
}

