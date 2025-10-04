terraform {
  required_providers {
    docker = {
      source  = "bierwirth-it/docker"
      version = "3.0.5"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.42.0"
    }
  }
  required_version = "~> 1.13.2"
}