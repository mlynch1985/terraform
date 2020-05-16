## Create our base S3 Bucket to hold configuration scripts/files
resource "aws_s3_bucket" "s3-configfiles" {
  bucket = "${var.namespace}-mltemp"
  acl    = "private"

  tags = {
    Name        = "${var.namespace}-mltemp"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
