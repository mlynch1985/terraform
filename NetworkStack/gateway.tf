resource "aws_internet_gateway" "igw" { vpc_id = aws_vpc.main.id }

resource "aws_eip" "eip-a" { vpc = true }
resource "aws_eip" "eip-b" { vpc = true }
resource "aws_eip" "eip-c" { vpc = true }

resource "aws_nat_gateway" "ngw-a" {
  allocation_id = aws_eip.eip-a.id
  subnet_id = aws_subnet.public-a.id
}

resource "aws_nat_gateway" "ngw-b" {
  allocation_id = aws_eip.eip-b.id
  subnet_id = aws_subnet.public-b.id
}

resource "aws_nat_gateway" "ngw-c" {
  allocation_id = aws_eip.eip-c.id
  subnet_id = aws_subnet.public-c.id
}