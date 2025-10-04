resource "aws_ecs_service" "service" {
  name                               = "${var.project_name}-ecs-service"
  cluster                            = aws_ecs_cluster.default.id
  task_definition                    = aws_ecs_task_definition.default.arn
  desired_count                      = var.ecs_task_desired_count
  deployment_minimum_healthy_percent = var.ecs_task_deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.ecs_task_deployment_maximum_percent
  launch_type                        = "FARGATE"

  load_balancer {
    target_group_arn = aws_alb_target_group.service_target_group.arn
    container_name   = var.project_name
    container_port   = var.container_port
  }

  network_configuration {
    security_groups  = [aws_default_security_group.infra.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
  }

  depends_on = [aws_alb_target_group.service_target_group]
  tags = {
    Name = "${var.project_name}-ecs-service"
  }
}