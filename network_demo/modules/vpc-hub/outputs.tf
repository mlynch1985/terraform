output "vpc_id" { value = aws_vpc.hub.id }
output "default_security_group" { value = aws_default_security_group.hub }
output "public_subnets" { value = aws_subnet.hub-public }
output "private_subnets" { value = aws_subnet.hub-private }
output "tgw_subnets" { value = aws_subnet.hub-tgw }
output "tgw_id" { value = aws_ec2_transit_gateway.hub.id }
output "tgw_arn" { value = aws_ec2_transit_gateway.hub.arn }
