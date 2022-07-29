resource "aws_instance" "this" {
  ## Required
  ami                    = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_groups
  subnet_id              = var.subnet_id

  ## Optional
  availability_zone           = var.availability_zone
  placement_group             = var.placement_group
  tenancy                     = var.tenancy
  host_id                     = var.host_id
  cpu_core_count              = var.cpu_core_count
  cpu_threads_per_core        = var.cpu_threads_per_core
  disable_api_termination     = var.disable_api_termination
  key_name                    = var.key_name
  monitoring                  = var.monitoring
  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.private_ip
  source_dest_check           = var.source_dest_check
  user_data                   = var.user_data
  iam_instance_profile        = var.iam_instance_profile

  dynamic "root_block_device" {
    for_each = var.root_block_device

    content {
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      kms_key_id            = lookup(root_block_device.value, "encrypted", false) ? aws_kms_key.this.arn : ""
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device

    content {
      device_name           = lookup(ebs_block_device.value, "device_name", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      kms_key_id            = lookup(ebs_block_device.value, "encrypted", false) ? aws_kms_key.this.arn : ""
    }
  }

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}"
    )
  )

  volume_tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}"
    )
  )
}
