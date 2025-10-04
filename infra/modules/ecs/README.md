<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.13.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.42.0 |
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | 3.0.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.42.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb) | resource |
| [aws_alb_listener.alb_http_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_target_group.service_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_default_security_group.infra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_ecr_repository.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_eip.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route53_health_check.route-53_healthcheck](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_health_check) | resource |
| [aws_route53_record.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.infra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_dns"></a> [app\_dns](#input\_app\_dns) | Domain name for the sample app | `string` | n/a | yes |
| <a name="input_aws_route53_zone_id"></a> [aws\_route53\_zone\_id](#input\_aws\_route53\_zone\_id) | AWS route53 zone id | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Port number exposed by the container | `number` | `80` | no |
| <a name="input_cpu_target_tracking_desired_value"></a> [cpu\_target\_tracking\_desired\_value](#input\_cpu\_target\_tracking\_desired\_value) | Target CPU usage percentage for autoscaling | `number` | `70` | no |
| <a name="input_cpu_units"></a> [cpu\_units](#input\_cpu\_units) | CPU units allocated to a single ECS task | `number` | `256` | no |
| <a name="input_ecs_task_deployment_maximum_percent"></a> [ecs\_task\_deployment\_maximum\_percent](#input\_ecs\_task\_deployment\_maximum\_percent) | Maximum percentage of additional tasks allowed during deployment | `number` | `100` | no |
| <a name="input_ecs_task_deployment_minimum_healthy_percent"></a> [ecs\_task\_deployment\_minimum\_healthy\_percent](#input\_ecs\_task\_deployment\_minimum\_healthy\_percent) | Minimum percentage of service required to be running during deployment | `number` | `50` | no |
| <a name="input_ecs_task_desired_count"></a> [ecs\_task\_desired\_count](#input\_ecs\_task\_desired\_count) | Desired number of ECS tasks to run in parallel | `number` | `3` | no |
| <a name="input_ecs_task_max_count"></a> [ecs\_task\_max\_count](#input\_ecs\_task\_max\_count) | Maximum number of ECS tasks to run in parallel | `number` | `10` | no |
| <a name="input_ecs_task_min_count"></a> [ecs\_task\_min\_count](#input\_ecs\_task\_min\_count) | Minimum number of ECS tasks to run in parallel | `number` | `2` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | IAM role | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory in MB allocated to a single ECS task | `number` | `512` | no |
| <a name="input_memory_target_tracking_desired_value"></a> [memory\_target\_tracking\_desired\_value](#input\_memory\_target\_tracking\_desired\_value) | Target memory usage percentage for autoscaling | `number` | `80` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | `"sap-infra"` | no |
| <a name="input_role"></a> [role](#input\_role) | Failover role | `string` | n/a | yes |
| <a name="input_target_capacity"></a> [target\_capacity](#input\_target\_capacity) | Percentage of container instance resources for task placement | `number` | `100` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block for the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | n/a |
<!-- END_TF_DOCS -->