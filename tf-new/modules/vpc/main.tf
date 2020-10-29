data "aws_availability_zones" "zones" {
  state = "available"
}

resource "aws_vpc" "this" {
    cidr_block = var.cidr_block
    enable_dns_support = var.enable_dns_support
    enable_dns_hostnames = var.enable_dns_hostnames

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.namespace}_vpc"
        )
    )
}

resource "aws_default_security_group" "this" {
    vpc_id = aws_vpc.this.id

    ingress {
        protocol = -1
        self = true
        from_port = 0
        to_port = 0
    }

    egress {
        protocol = -1
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.namespace}_sg_default"
        )
    )
}

resource "aws_internet_gateway" "igw" {
    count = var.deploy_public_subnets ? 1 : 0

    vpc_id = aws_vpc.this.id

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.namespace}_igw"
        )
    )
}

resource "aws_subnet" "public" {
    count = var.deploy_public_subnets ? var.target_az_count : 0

    vpc_id = aws_vpc.this.id
    cidr_block = cidrsubnet(var.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zones.zones.names[count.index]
    map_public_ip_on_launch = true

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.namespace}_public_${count.index}"
        )
    )
}

resource "aws_route_table" "public" {
    count = var.deploy_public_subnets ? 1 : 0

    vpc_id = aws_vpc.this.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw[0].id
    }

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.namespace}_rtb_public"
        )
    )
}

resource "aws_route_table_association" "public" {
    count = var.deploy_public_subnets ? var.target_az_count : 0

    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public[0].id
}



resource "aws_subnet" "private" {
    count = var.deploy_private_subnets ? var.target_az_count : 0

    vpc_id = aws_vpc.this.id
    cidr_block = cidrsubnet(var.cidr_block, 8, count.index + var.target_az_count)
    availability_zone = data.aws_availability_zones.zones.names[count.index]
    map_public_ip_on_launch = false

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.namespace}_private_${count.index}"
        )
    )
}

resource "aws_eip" "private" {
    count = var.deploy_private_subnets ? var.target_az_count : 0

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.namespace}_eip_${count.index}"
        )
    )
}

resource "aws_nat_gateway" "private" {
    count = var.deploy_private_subnets ? var.target_az_count : 0

    allocation_id = aws_eip.private[count.index].id
    subnet_id = aws_subnet.private[count.index].id

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.namespace}_ngw_${count.index}"
        )
    )
}

resource "aws_route_table" "private" {
    count = var.deploy_private_subnets ? var.target_az_count : 0

    vpc_id = aws_vpc.this.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.private[count.index].id
    }

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.namespace}_rtb_private"
        )
    )
}

resource "aws_route_table_association" "private" {
    count = var.deploy_private_subnets ? var.target_az_count : 0

    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private[count.index].id
}



resource "aws_subnet" "protected" {
    count = var.deploy_protected_subnets ? var.target_az_count : 0

    vpc_id = aws_vpc.this.id
    cidr_block = cidrsubnet(var.cidr_block, 8, count.index + var.target_az_count + var.target_az_count)
    availability_zone = data.aws_availability_zones.zones.names[count.index]
    map_public_ip_on_launch = false

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.namespace}_protected_${count.index}"
        )
    )
}

resource "aws_route_table" "protected" {
    count = var.deploy_protected_subnets ? var.target_az_count : 0

    vpc_id = aws_vpc.this.id

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.namespace}_rtb_protected"
        )
    )
}

resource "aws_route_table_association" "protected" {
    count = var.deploy_protected_subnets ? var.target_az_count : 0

    subnet_id = aws_subnet.protected[count.index].id
    route_table_id = aws_route_table.protected[count.index].id
}