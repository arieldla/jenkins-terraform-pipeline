# Jenkins Terraform Pipeline

A production-style Jenkins CI/CD pipeline that executes Terraform against AWS,
using IAM Roles Anywhere for keyless authentication and S3 + DynamoDB for remote state.

## What This Builds

A full CI/CD loop for infrastructure:

1. Developer pushes Terraform code to Gitea/GitHub
2. Jenkins detects the push via webhook
3. Pipeline authenticates to AWS using IAM Roles Anywhere (no static keys)
4. `terraform plan` runs and output is posted as a build artifact
5. Manual approval gate before `terraform apply`
6. State stored in S3 (`dla-tstate`), locks managed by DynamoDB

## Pipeline Stages

```
Checkout --> Auth (IAM Roles Anywhere) --> Init --> Validate --> Plan --> [Approval] --> Apply
                                                                              |
                                                                         (on PR: plan only, no apply)
```

## Repository Structure

```
.
|-- Jenkinsfile                  # Main pipeline definition
|-- modules/
|   |-- vpc/                     # VPC module (10.10.0.0/16, 10.20.0.0/16)
|   |-- security-groups/
|   |-- s3/
|   `-- iam/
|-- environments/
|   |-- dev/
|   `-- prod/
`-- backend.tf                   # S3 backend config (Pick a unique name)
```

## Backend Configuration

```hcl
terraform {
  backend "s3" {
    bucket         = "Pick a unique name"
    key            = "pipeline/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "Pick a Name"
    encrypt        = true
  }
}
```

## Authentication

Credentials come from IAM Roles Anywhere — see
[jenkins-iam-roles-anywhere](https://github.com/arieldla/jenkins-iam-roles-anywhere)
for full setup. No IAM user keys. No credentials stored in Jenkins.

## AWS Environment

| Setting | Value |
|---|---|
| Account | Your-Account|
| Region | us-east-1 |
| VPC CIDR 1 | 10.10.0.0/16 |
| VPC CIDR 2 | 10.20.0.0/16 |
| State Bucket | Your Bucket for storing the tstate |
| IAM Role | JenkinsLabRole |

## Exam Relevance

| Cert | Concept |
|---|---|
| AWS SAA-C03 | VPC design, S3, IAM, state management |
| AWS SCS-C03 | Least privilege, credential-free CI/CD, S3 encryption |
| AZ-104 | Infrastructure lifecycle management patterns |

## Prerequisites

- Jenkins instance with IAM Roles Anywhere configured
- AWS CLI and Terraform installed in Jenkins agent
- `Your Bucket for storing the tstate` S3 bucket and DynamoDB lock table provisioned
- See [jenkins-iam-roles-anywhere](https://github.com/arieldla/jenkins-iam-roles-anywhere)

## Related Repos

- [jenkins-iam-roles-anywhere](https://github.com/arieldla/jenkins-iam-roles-anywhere) — Auth layer
- [jenkins-shared-library](https://github.com/arieldla/jenkins-shared-library) — Reusable pipeline steps
- [jenkins-labs](https://github.com/arieldla/jenkins-labs) — Lab series this pipeline evolved from
