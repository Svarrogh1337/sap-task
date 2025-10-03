provider "aws" {
  alias = "euc1"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "euw2"
  region = "eu-west-1"
}

resource "aws_route53_zone" "primary" {
  name = "app.hhristov.info"
}

module "ecs-primary" {
  vpc_cidr_block = "10.0.0.0/16"
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn
  project_name = "sap-infra-primary"
  source = "./modules/ecs"
  providers = {
    aws = aws.euc1
  }
  aws_route53_zone_id = aws_route53_zone.primary.zone_id
  role                = "PRIMARY"
}
module "ecs-secondary" {
  vpc_cidr_block = "10.1.0.0/16"
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn
  project_name = "sap-infra-secondary"
  source = "./modules/ecs"
  providers = {
    aws = aws.euw2
  }
  aws_route53_zone_id = aws_route53_zone.primary.zone_id
  role                = "SECONDARY"
}
terraform {
  backend "s3" {
    bucket = "tf-bknd"
    key    = "terraform/state"
    region = "eu-central-1"
    use_lockfile = true
  }
}