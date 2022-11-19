output "ipam_id" { value = aws_vpc_ipam.main.id }
output "ipam_arn" { value = aws_vpc_ipam.main.arn }
output "pool_id" { value = aws_vpc_ipam_pool.main.id }
output "pool_arn" { value = aws_vpc_ipam_pool.main.arn }
output "cidr" { value = aws_vpc_ipam_pool_cidr.main.cidr }
