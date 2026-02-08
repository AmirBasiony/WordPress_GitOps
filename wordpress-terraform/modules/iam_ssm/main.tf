data "aws_iam_role" "app_role" {
  name = var.app_role_name
}

data "aws_iam_role" "ec2_ssm_role" {
  name = var.ssm_role_name
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.name_prefix}-app-profile"
  role = data.aws_iam_role.app_role.name

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-app-profile"
    Owner = var.owner
  })
}

resource "aws_iam_instance_profile" "mysql_profile" {
  name = "${var.name_prefix}-mysql-profile"
  role = data.aws_iam_role.ec2_ssm_role.name

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-mysql-profile"
    Owner = var.owner
  })
}

data "aws_iam_policy_document" "ansible_ssm_s3_policy" {
  statement {
    sid = "AnsibleSSMBucketAccess"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:HeadBucket"
    ]
    resources = [
      var.ansible_ssm_bucket_arn,
      "${var.ansible_ssm_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "ansible_ssm_s3" {
  name   = "${var.name_prefix}-ansible-ssm-s3"
  policy = data.aws_iam_policy_document.ansible_ssm_s3_policy.json

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-ansible-ssm-s3"
    Owner = var.owner
  })
}

resource "aws_iam_role_policy_attachment" "attach_ansible_ssm_s3" {
  role       = data.aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.ansible_ssm_s3.arn
}
