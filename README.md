# Jenkins Terraform Pipeline

CI/CD pipeline demonstrating Terraform infrastructure deployment via Jenkins with 
IAM Roles Anywhere authentication. No static AWS credentials stored anywhere.

## Auth Flow
Jenkins → aws_signing_helper → IAM Roles Anywhere → JenkinsRolesAnywhereRole → AWS

## Usage
Run with ACTION=plan, ACTION=apply, or ACTION=destroy
