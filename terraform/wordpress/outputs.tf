
output "wordpress_service_ip" {
  description = "Public IP of the WordPress Service"
  value       = kubernetes_service.wordpress_service.load_balancer_ingress.0.hostname
}
