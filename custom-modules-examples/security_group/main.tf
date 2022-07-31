resource "aws_security_group" "this" {
  # Allows us to apply changes that require replacement of this security group
  lifecycle {
    create_before_destroy = true
  }

  name_prefix = "${var.group_name_prefix}-"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.group_name_prefix
  }
}

resource "aws_security_group_rule" "this" {
  for_each = { for rule in var.rules : rule.type => rule }

  cidr_blocks              = [each.value.cidr_blocks != "" ? each.value.cidr_blocks : null]
  description              = each.value.description != "" ? each.value.description : null
  from_port                = each.value.from_port
  protocol                 = each.value.protocol
  security_group_id        = aws_security_group.this.id
  source_security_group_id = each.value.source_security_group_id != "" ? each.value.source_security_group_id : null
  to_port                  = each.value.to_port
  type                     = each.value.type
}
