terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "pipeline_demo" {
  bucket = "jenkins-pipeline-demo-${data.aws_caller_identity.current.account_id}-${var.environment}"

  tags = {
    Name        = "jenkins-pipeline-demo"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
    DeployedBy  = "jenkins-iam-roles-anywhere"
    CreatedDate = timestamp()
  }
}

resource "aws_s3_bucket_versioning" "pipeline_demo" {
  bucket = aws_s3_bucket.pipeline_demo.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pipeline_demo" {
  bucket = aws_s3_bucket.pipeline_demo.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "pipeline_demo" {
  bucket                  = aws_s3_bucket.pipeline_demo.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
