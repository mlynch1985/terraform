output "vpc" { value = aws_vpc.vpc }
output "public_subnets" { value = aws_subnet.public }
output "private_subnets" { value = aws_subnet.private }
output "sg_common" { value = aws_security_group.common }
