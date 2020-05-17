## Define Cloudformation Template used to generate unique user password
resource "aws_cloudformation_stack" "cfn-windowsjump-secret" {
  name = "${var.namespace}-windowsjump-secret"
  parameters = {
    namespace = var.namespace
    environment = var.environment
    KmsKey = aws_kms_key.kms-key-windowsjump.id

  }
  template_body = file("${path.module}/cloudformation.yml")
}
