variable "environment" {
  description = "Environment name"
  type        = string
  default     = "lab"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "jenkins-pipeline-demo"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
