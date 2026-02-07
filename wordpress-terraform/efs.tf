resource "aws_efs_file_system" "app_efs" {
  creation_token   = "amir-wp-efs"
  encrypted        = true
  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  lifecycle_policy {
    transition_to_archive = "AFTER_90_DAYS"
  }

  tags = {
    Name  = "amir-wp-efs"
    Owner = "amir"
  }
}

# Backups are configured via a separate resource
resource "aws_efs_backup_policy" "app_efs_backup" {
  file_system_id = aws_efs_file_system.app_efs.id

  backup_policy {
    status = "ENABLED"
  }
}


resource "aws_efs_mount_target" "efs_mt_privates" {
  for_each        = local.private_subnet_ids
  file_system_id  = aws_efs_file_system.app_efs.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs_sg.id]
}