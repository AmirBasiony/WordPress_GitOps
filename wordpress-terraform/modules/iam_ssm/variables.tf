variable "name_prefix" {
  type    = string
  default = "wp"
}
variable "owner" {
  type    = string
  default = "unknown"
}
variable "tags" {
  type    = map(string)
  default = {}
}

variable "app_role_name" {
  type    = string
  default = "ASG-Access-Role-to-S3-SSM"
}
variable "ssm_role_name" {
  type    = string
  default = "EC2-SSM-Role"
}

variable "ansible_ssm_bucket_arn" {
  type = string
}
