output "vpc" { value = aws_vpc.vpc }
output "default_security_group" { value = aws_default_security_group.default }
output "public_subnets" { value = aws_subnet.public }
output "private_subnets" { value = aws_subnet.private }
