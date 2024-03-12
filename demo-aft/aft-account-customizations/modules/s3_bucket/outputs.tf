# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

output "id" { value = aws_s3_bucket.this.id }
output "arn" { value = aws_s3_bucket.this.arn }
output "region" { value = aws_s3_bucket.this.region }
output "domain_name" { value = aws_s3_bucket.this.bucket_domain_name }
output "hosted_zone_id" { value = aws_s3_bucket.this.hosted_zone_id }
output "name" { value = aws_s3_bucket.this.id }
output "regional_domain_name" { value = aws_s3_bucket.this.bucket_regional_domain_name }
