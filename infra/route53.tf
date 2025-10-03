resource "aws_route53_zone" "primary" {
  name = "app.hhristov.info"
}
resource "aws_route53_record" "primary" {
  zone_id        = aws_route53_zone.primary.id
  name           = "test.app.hhristov.info"
  type           = "A"
  set_identifier = "${var.project_name}-primary"

    alias {
      name                   = aws_alb.alb.dns_name
      zone_id                = aws_alb.alb.zone_id
      evaluate_target_health = true
    }

  failover_routing_policy {
    type = "PRIMARY"
  }
}
resource "aws_route53_record" "secondary" {
  zone_id        = aws_route53_zone.primary.id
  name           = "test.app.hhristov.info"
  type           = "A"
  set_identifier = "${var.project_name}-secondary"

  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = true
  }

  failover_routing_policy {
    type = "SECONDARY"
  }
}