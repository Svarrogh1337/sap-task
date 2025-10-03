resource "aws_ecs_task_definition" "default" {
  family                   = "${var.project_name}-ecs-task-def"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = var.cpu_units
  memory                   = var.memory

  container_definitions = jsonencode([
    {
      name         = var.project_name
      image        = "${aws_ecr_repository.app.repository_url}:amd64"
      cpu          = var.cpu_units
      memory       = var.memory
      essential    = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          "awslogs-group"         = aws_cloudwatch_log_group.log_group.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "${var.project_name}-log-stream"
        }
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-ecs-task-def"
  }
}