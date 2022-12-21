output "vpc_id" { value = aws_vpc.vpc.id }
output "default_security_group" { value = aws_default_security_group.default }
output "private_subnets" { value = aws_subnet.private }
output "transit_subnets" { value = aws_subnet.transit }
