# SAP Infrastructure - AWS ECS Multi-Region Deployment

![Architecture Design](images/design.svg)

## Overview

This project implements a highly available, multi-region AWS infrastructure using ECS (Elastic Container Service) with Route53 failover capabilities. The infrastructure is designed with a PRIMARY region in `eu-central-1` and a SECONDARY region in `eu-west-1` for disaster recovery and high availability.

## Architecture

The infrastructure consists of:

- **Multi-Region Setup**: Two AWS regions (eu-central-1 and eu-west-1)
- **ECS Fargate**: Containerized application deployment
- **Application Load Balancer**: Traffic distribution across ECS tasks
- **Route53**: DNS management with failover routing policy
- **VPC**: Isolated network environments with dedicated CIDR blocks
- **Auto Scaling**: Dynamic scaling based on CPU and memory metrics
- **CloudWatch**: Monitoring and logging

## Project Structure

```text
.
├── app/                      # Go application source code
│   ├── main.go              # Application entry point
│   ├── models/              # Data models
│   ├── routes/              # API routes
│   ├── go.mod               # Go dependencies
│   └── Dockerfile           # Application container image
├── infra/                   # Terraform infrastructure code
│   ├── main.tf              # Root module configuration
│   ├── variables.tf         # Root variables
│   ├── iam.tf               # IAM roles and policies
│   ├── terraform.tf         # Terraform configuration
│   ├── Dockerfile           # Terraform container image
│   └── modules/
│       └── ecs/             # ECS module
│           ├── alb.tf       # Application Load Balancer
│           ├── ecr.tf       # Elastic Container Registry
│           ├── ecs.tf       # ECS cluster configuration
│           ├── network.tf   # VPC, subnets, security groups
│           ├── route53.tf   # DNS records
│           ├── service.tf   # ECS service
│           ├── task_definition.tf
│           ├── cloudwatch.tf
│           └── variables.tf
├── images/                  # Architecture diagrams
├── Makefile                 # Build and deployment automation
└── README.md               # This file
```

## Prerequisites

- AWS Account with appropriate permissions
- Terraform/OpenTofu >= 1.0
- AWS CLI configured
- Go 1.25+ (for application development)
- Docker (for containerization)

## Infrastructure Components

### Primary Region (eu-central-1)
- VPC CIDR: `10.0.0.0/16`
- Project Name: `sap-infra-primary`
- Role: `PRIMARY`

### Secondary Region (eu-west-1)
- VPC CIDR: `10.1.0.0/16`
- Project Name: `sap-infra-secondary`
- Role: `SECONDARY`

### Key Resources

- **Route53 Hosted Zone**: `eko.dev`
- **ECS Task Configuration**:
    - Desired Count: 3
    - Min Count: 2
    - Max Count: 10
    - CPU: 256 units
    - Memory: 512 MB
    - Container Port: 80

### Auto Scaling Targets

- **CPU Target**: 70%
- **Memory Target**: 80%
- **Deployment Strategy**:
    - Minimum Healthy: 50%
    - Maximum Percent: 100%

## Configuration

### Required Variables

```hcl
domain_name           = "eko.dev"           # Domain name for Route53
aws_route53_zone_id   = "<ZONE_ID>"        # Route53 zone ID
```

### Optional Variables

All optional variables have sensible defaults. See `infra/variables.tf` for the complete list.

## Deployment

### Initialize Terraform

```bash
cd infra
terraform init
```

### Plan Infrastructure

```bash
terraform plan
```

### Apply Infrastructure

```bash
make apply
```

### E2E Deployment

```bash
make e2e-deploy
```

### Destroy Infrastructure

```bash
make destroy
```

## Backend Configuration

The Terraform state is stored in an S3 backend:

- **Bucket**: `tf-bknd`
- **Key**: `terraform/state`
- **Region**: `eu-central-1`
- **Lock File**: Enabled

## Application

The application is a Go-based web service that runs on port 80. It's containerized using Docker and deployed to ECS Fargate in both regions.

### Building the Application

```bash
make app-build
```

## Monitoring

CloudWatch is configured for:
- ECS task logs
- Container metrics
- Auto-scaling metrics
- Application Load Balancer metrics

## High Availability

The infrastructure implements several HA strategies:
1. **Multi-AZ Deployment**: Resources span multiple availability zones
2. **Auto Scaling**: Automatic scaling based on metrics
3. **Health Checks**: ALB performs health checks on ECS tasks
4. **Route53 Failover**: Automatic DNS failover between regions
5. **Rolling Deployments**: Zero-downtime deployments

## Security
- VPC isolation with public and private subnets
- Security groups restricting traffic
- IAM roles with the least privilege access
- Container image scanning via ECR