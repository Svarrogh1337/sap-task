resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "default" {
  count                = var.deploy_db ? 1 : 0
  allocated_storage    = 10
  db_name              = "${replace(var.project_name, "-", "")}db"
  db_subnet_group_name = aws_db_subnet_group.db-subnet.name
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = random_password.password.result
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}
