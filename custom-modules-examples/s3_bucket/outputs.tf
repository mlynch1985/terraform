output "arn" { value = aws_s3_bucket.this.arn }
output "domain_name" { value = aws_s3_bucket.this.bucket_domain_name }
output "hosted_zone_id" { value = aws_s3_bucket.this.hosted_zone_id }
output "name" { value = aws_s3_bucket.this.id }
output "regional_domain_name" { value = aws_s3_bucket.this.bucket_regional_domain_name }
