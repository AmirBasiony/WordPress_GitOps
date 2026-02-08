data "aws_caller_identity" "current" {}

locals {
  generated_bucket_name = "${var.name_prefix}-ansible-ssm-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
  ssm_bucket_name       = var.ssm_bucket_name_override != "" ? var.ssm_bucket_name_override : local.generated_bucket_name
}

resource "aws_s3_bucket" "ssm" {
  bucket = local.ssm_bucket_name

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-ansible-ssm-bucket"
    Owner = var.owner
  })
}

resource "aws_s3_bucket_public_access_block" "ssm" {
  bucket = aws_s3_bucket.ssm.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_efs_file_system" "this" {
  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-efs"
    Owner = var.owner
  })
}

resource "aws_efs_backup_policy" "this" {
  count          = var.enable_efs_backup ? 1 : 0
  file_system_id = aws_efs_file_system.this.id

  backup_policy { status = "ENABLED" }
}

resource "aws_efs_mount_target" "mt" {
  for_each = {
    "subnet-1" = var.private_subnet_ids[0]
    "subnet-2" = var.private_subnet_ids[1]
  }
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = [var.efs_sg_id]
}
