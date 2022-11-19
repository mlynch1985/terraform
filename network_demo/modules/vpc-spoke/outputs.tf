output "vpc_id" { value = aws_vpc.spoke.id }
output "default_security_group" { value = aws_default_security_group.spoke }
output "private_subnets" { value = aws_subnet.spoke-private }
output "tgw_subnets" { value = aws_subnet.spoke-tgw }
