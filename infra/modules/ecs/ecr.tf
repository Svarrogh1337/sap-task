resource "aws_ecr_repository" "app" {
  name = "${var.project_name}-app"
  image_scanning_configuration {
    scan_on_push = false
  }
  force_delete = true
  tags = {
    Name = "${var.project_name}-ecr"
  }
}