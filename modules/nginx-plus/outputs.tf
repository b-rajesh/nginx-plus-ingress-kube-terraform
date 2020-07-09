output "lb_ip" {
  value = kubernetes_service.nginx-ingress-service.load_balancer_ingress[0].ip
}

