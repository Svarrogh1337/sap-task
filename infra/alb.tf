resource "aws_alb" "alb" {
  name            = "${var.project_name}-alb"
  security_groups = [aws_default_security_group.infra.id]
  subnets         = aws_subnet.public.*.id

  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_alb_listener" "alb_http_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.service_target_group.id
    type             = "forward"
  }

  tags = {
    Name = "${var.project_name}-http-listener"
  }
}

resource "aws_alb_target_group" "service_target_group" {
  name                 = "${var.project_name}-tg"
  port                 = var.container_port
  protocol             = "HTTP"
  vpc_id               = aws_vpc.infra.id
  deregistration_delay = 5
  target_type          = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    matcher             = 200
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 30
  }

  tags = {
    Name = "${var.project_name}-tg"
  }

  depends_on = [aws_alb.alb]
}
output "lb_dns_name" {
  value = aws_alb.alb.dns_name
}