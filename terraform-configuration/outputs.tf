#Log the load balancer app URL
output "app_url" {
  value = aws_lb.default.dns_name
}
