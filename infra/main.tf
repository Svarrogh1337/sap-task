provider "aws" {
  region = var.aws_region
}
terraform {
  backend "s3" {
    bucket = "tf-bknd"
    key    = "terraform/state"
    region = "eu-central-1"
    use_lockfile = true
  }
}