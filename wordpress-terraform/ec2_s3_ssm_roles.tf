###############################
#           IAM              #
###############################

# IAM Role and Instance Profile for EC2 instances to access S3 and SSM
data "aws_iam_role" "app_role" {
  name = "ASG-Access-Role-to-S3-SSM"
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "amir-wp-app-profile"
  role = data.aws_iam_role.app_role.name

  tags = {
    Name  = "amir-wp-app-profile"
    Owner = "amir"
  }
}

# MySQL IAM Role and Instance Profile for EC2 instances to access SSM only
data "aws_iam_role" "ec2_ssm_role" {
  name = "EC2-SSM-Role"
}

resource "aws_iam_instance_profile" "mysql_profile" {
  name = "amir-wp-mysql-profile"
  role = data.aws_iam_role.ec2_ssm_role.name

  tags = {
    Name  = "amir-wp-mysql-profile"
    Owner = "amir"
  }
}


# IAM Policy for S3 access from EC2 instances via SSM
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
      aws_s3_bucket.ansible_ssm_bucket.arn,
      "${aws_s3_bucket.ansible_ssm_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "ansible_ssm_s3" {
  name   = "amir-wp-ansible-ssm-s3"
  policy = data.aws_iam_policy_document.ansible_ssm_s3_policy.json

  tags = {
    Name  = "amir-wp-ansible-ssm-s3"
    Owner = "amir"
  }
}

resource "aws_iam_role_policy_attachment" "attach_ansible_ssm_s3" {
  role       = data.aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.ansible_ssm_s3.arn
}

 
# IAM Policy Document for S3 bucket access from EC2 instances via SSM
data "aws_iam_policy_document" "ansible_ssm_bucket_policy_doc" {
  statement {
    sid = "AnsibleSSMBucketAccess"

    # Define the actions allowed on the S3 bucket
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:HeadBucket"
    ]

    # Specify the resources (S3 bucket and its objects) the policy applies to
    resources = [
      aws_s3_bucket.ansible_ssm_bucket.arn,
      "${aws_s3_bucket.ansible_ssm_bucket.arn}/*"
    ]
  }
}

# IAM Policy resource to apply the above policy document
resource "aws_iam_policy" "ansible_ssm_bucket_policy" {
  name   = "amir-wp-ansible-ssm-bucket-policy"
  policy = data.aws_iam_policy_document.ansible_ssm_bucket_policy_doc.json

  # Tags for identifying and managing the policy
  tags = {
    Name  = "amir-wp-ansible-ssm-bucket-policy"
    Owner = "amir"
  }
}
