resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.project_name}-ecs-x-iam"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role_policy.json

  tags = {
    Name = "${var.project_name}-ecs-x-iam"
  }
}

data "aws_iam_policy_document" "task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role" "ecs_task_iam_role" {
  name               = "${var.project_name}-ecs-task-iam-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role_policy.json

  tags = {
    Name = "${var.project_name}-ecs-task-iam-role"
  }
}