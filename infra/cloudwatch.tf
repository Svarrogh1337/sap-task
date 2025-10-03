resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/${var.project_name}/ecs/"
  retention_in_days = 1

  tags = {
    Name = "${var.project_name}-lg"
  }
}