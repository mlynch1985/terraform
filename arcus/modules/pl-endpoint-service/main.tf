resource "aws_vpc_endpoint_service" "this" {
  acceptance_required        = false
  allowed_principals         = var.allowed_principals
  network_load_balancer_arns = var.network_load_balancer_arns
}
