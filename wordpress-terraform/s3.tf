data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "ansible_ssm_bucket" {
  bucket = "amir-wp-ansible-ssm-${data.aws_caller_identity.current.account_id}-${var.aws_region}"

  tags = {
    Name  = "amir-wp-ansible-ssm-bucket"
    Owner = "amir"
  }
}
resource "aws_s3_bucket_public_access_block" "ansible_ssm_bucket_pab" {
  bucket = aws_s3_bucket.ansible_ssm_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
