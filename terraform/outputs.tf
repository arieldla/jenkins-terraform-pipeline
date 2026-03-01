output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.pipeline_demo.bucket
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.pipeline_demo.arn
}

output "deployed_by_role" {
  description = "IAM role used for deployment"
  value       = data.aws_caller_identity.current.arn
}
