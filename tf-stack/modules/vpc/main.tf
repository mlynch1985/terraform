resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.default_tags.namespace}_vpc"
        )
    )
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public" {
    count = var.az_count

    availability_zone = element(var.az_list.names, count.index)
    cidr_block = cidrsubnet(var.cidr_block, 8, count.index)
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.vpc.id

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.default_tags.namespace}_public_${count.index + 1}",
            "tier", "public"
        )
    )
}

resource "aws_subnet" "private" {
    count = var.az_count

    availability_zone = element(var.az_list.names, count.index)
    cidr_block = cidrsubnet(var.cidr_block, 8, count.index + var.az_count)
    map_public_ip_on_launch = false
    vpc_id = aws_vpc.vpc.id

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.default_tags.namespace}_private_${count.index + 1}",
            "tier", "private"
        )
    )
}

resource "aws_eip" "eip" {
    count = var.az_count

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.default_tags.namespace}_eip_${count.index + 1}"
        )
    )
}

resource "aws_nat_gateway" "ngw" {
    count = var.az_count

    allocation_id = element(aws_eip.eip.*.id, count.index)
    subnet_id = element(aws_subnet.public.*.id, count.index)

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.default_tags.namespace}_ngw_${count.index + 1}"
        )
    )
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.default_tags.namespace}_public_rtb"
        )
    )
}

resource "aws_route_table" "private" {
    count = var.az_count

    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
    }

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.default_tags.namespace}_private_rtb_${count.index + 1}"
        )
    )
}

resource "aws_route_table_association" "public" {
    count = var.az_count

    subnet_id = element(aws_subnet.public.*.id, count.index)
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count = var.az_count

    subnet_id = element(aws_subnet.private.*.id, count.index)
    route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_security_group" "common" {
    name = "${var.default_tags.namespace}_common"
    description = "Allows connectivity from all servers in terraform stack"
    vpc_id = aws_vpc.vpc.id

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.default_tags.namespace}_common"
        )
    )
}
