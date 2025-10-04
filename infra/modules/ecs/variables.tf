data "aws_availability_zones" "available" {
  state = "available"
}
variable "app_dns" {
  description = "Domain name for the sample app"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM role "
  type = string
}
variable "aws_route53_zone_id" {
  description = "AWS route53 zone id"
  type        = string
}
variable "role" {
  description = "Failover role"
  type        = string
}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "sap-infra"
}

variable "ecs_task_desired_count" {
  description = "Desired number of ECS tasks to run in parallel"
  type        = number
  default     = 3
}

variable "ecs_task_min_count" {
  description = "Minimum number of ECS tasks to run in parallel"
  default     = 2
  type        = number
}

variable "ecs_task_max_count" {
  description = "Maximum number of ECS tasks to run in parallel"
  default     = 10
  type        = number
}

variable "ecs_task_deployment_minimum_healthy_percent" {
  description = "Minimum percentage of service required to be running during deployment"
  default     = 50
  type        = number
}

variable "ecs_task_deployment_maximum_percent" {
  description = "Maximum percentage of additional tasks allowed during deployment"
  default     = 100
  type        = number
}

variable "cpu_target_tracking_desired_value" {
  description = "Target CPU usage percentage for autoscaling"
  default     = 70
  type        = number
}

variable "memory_target_tracking_desired_value" {
  description = "Target memory usage percentage for autoscaling"
  default     = 80
  type        = number
}

variable "target_capacity" {
  description = "Percentage of container instance resources for task placement"
  default     = 100
  type        = number
}

variable "container_port" {
  description = "Port number exposed by the container"
  type        = number
  default     = 80
}

variable "cpu_units" {
  description = "CPU units allocated to a single ECS task"
  default     = 256
  type        = number
}

variable "memory" {
  description = "Memory in MB allocated to a single ECS task"
  default     = 512
  type        = number
}