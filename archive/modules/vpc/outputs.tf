output "vpc" { value = aws_vpc.this }
output "default_security_group" { value = aws_default_security_group.this }
output "public_subnets" { value = aws_subnet.public }
output "private_subnets" { value = aws_subnet.private }
