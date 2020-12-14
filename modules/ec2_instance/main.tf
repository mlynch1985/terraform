resource "aws_instance" "root_only" {
  count = var.enable_second_drive ? 0 : 1

  ami                         = var.image_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = var.enable_detailed_monitoring
  vpc_security_group_ids      = var.security_groups
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = var.user_data
  iam_instance_profile        = var.iam_instance_profile

  root_block_device {
    volume_type           = var.root_block_device.volume_type
    volume_size           = var.root_block_device.volume_size
    delete_on_termination = var.root_block_device.delete_on_termination
    encrypted             = var.root_block_device.encrypted
    kms_key_id            = var.root_block_device.encrypted ? aws_kms_key.this.key_id : ""
  }

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}"
    )
  )
}
resource "aws_instance" "with_ebs" {
  count = var.enable_second_drive ? 1 : 0

  ami                         = var.image_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = var.enable_detailed_monitoring
  vpc_security_group_ids      = var.security_groups
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = var.user_data
  iam_instance_profile        = var.iam_instance_profile

  root_block_device {
    volume_type           = var.root_block_device.volume_type
    volume_size           = var.root_block_device.volume_size
    delete_on_termination = var.root_block_device.delete_on_termination
    encrypted             = var.root_block_device.encrypted
    kms_key_id            = var.root_block_device.encrypted ? aws_kms_key.this.key_id : ""
  }

  ebs_block_device {
    device_name           = var.ebs_block_device.device_name
    volume_type           = var.ebs_block_device.volume_type
    volume_size           = var.ebs_block_device.volume_size
    delete_on_termination = var.ebs_block_device.delete_on_termination
    encrypted             = var.ebs_block_device.encrypted
    kms_key_id            = var.ebs_block_device.encrypted ? aws_kms_key.this.key_id : ""
  }

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}"
    )
  )
}
