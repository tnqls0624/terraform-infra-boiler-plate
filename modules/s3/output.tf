# S3
output "s3" {
  description = <<EOT
  S3 Bucket Outputs
  - Map Key: Bucket Name
  - Map Value: Bucket Configurations
    - `bucket`: Created Bucket Name
EOT
  value       = {
    for n in var.s3.names : n => {
      bucket : aws_s3_bucket.this[n].bucket
    }
  }
}
