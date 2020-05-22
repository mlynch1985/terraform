## Define Cloudformation Template used to generate unique user password
resource "aws_cloudformation_stack" "windowsjump" {
  name = "${var.namespace}-windowsjump"
  parameters = {
    namespace   = var.namespace
    environment = var.environment
    KmsKey      = aws_kms_key.windowsjump.id

  }
  template_body = file("${path.module}/cloudformation.yml")
}
