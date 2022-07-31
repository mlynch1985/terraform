output "ipam_id" { value = aws_vpc_ipam.this.id }
output "ipam_arn" { value = aws_vpc_ipam.this.arn }
output "pool_id" { value = aws_vpc_ipam_pool.this.id }
output "pool_arn" { value = aws_vpc_ipam_pool.this.arn }
output "cidr" { value = aws_vpc_ipam_pool_cidr.this.cidr }
