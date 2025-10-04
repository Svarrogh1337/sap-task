terraform {
  backend "s3" {
    bucket       = "tf-bknd"
    key          = "terraform/state"
    region       = "eu-central-1"
    use_lockfile = true
  }
  required_version = "~> 1.13.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.42.0"
    }
  }
}
