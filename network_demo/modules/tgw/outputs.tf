output "ec2_transit_gateway_arn" {
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
  value       = aws_ec2_transit_gateway.this.arn
}

output "ec2_transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = aws_ec2_transit_gateway.this.id
}

output "ec2_transit_gateway_owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
  value       = aws_ec2_transit_gateway.this.owner_id
}

output "ec2_transit_gateway_association_default_route_table_id" {
  description = "Identifier of the default association route table"
  value       = aws_ec2_transit_gateway.this.association_default_route_table_id
}

output "ec2_transit_gateway_propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = aws_ec2_transit_gateway.this.propagation_default_route_table_id
}

output "ram_resource_share_id" {
  description = "The Amazon Resource Name (ARN) of the resource share"
  value       = aws_ram_resource_share.this[*].id
}

output "ram_principal_association_id" {
  description = "The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma"
  value       = aws_ram_principal_association.this[*].id
}
