resource "aws_route53_record" "primary" {
  zone_id        = var.aws_route53_zone_id
  name           = "test.app.hhristov.info"
  type           = "A"
  set_identifier = "${var.project_name}-primary"

    alias {
      name                   = aws_alb.alb.dns_name
      zone_id                = aws_alb.alb.zone_id
      evaluate_target_health = true
    }

  failover_routing_policy {
    type = var.role
  }
}
