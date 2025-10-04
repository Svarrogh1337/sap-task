resource "aws_route53_record" "primary" {
  zone_id        = var.aws_route53_zone_id
  name           = var.app_dns
  type           = "A"
  set_identifier = var.project_name
  health_check_id = aws_route53_health_check.route-53_healthcheck.id
    alias {
      name                   = aws_alb.alb.dns_name
      zone_id                = aws_alb.alb.zone_id
      evaluate_target_health = true
    }

  failover_routing_policy {
    type = var.role
  }
}
resource "aws_route53_health_check" "route-53_healthcheck" {
  fqdn              = aws_alb.alb.dns_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/health"
  failure_threshold = "2"
  request_interval  = "10"
  tags = {
    Name = "${var.project_name}-${var.role}-healthcheck"
  }
}