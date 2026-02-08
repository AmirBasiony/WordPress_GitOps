variable "name_prefix" {
  type = string
}
variable "owner" {
  type    = string
  default = "unknown"
}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "aws_region" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}
variable "efs_sg_id" {
  type = string
}

variable "enable_efs_backup" {
  type    = bool
  default = true
}

variable "ssm_bucket_name_override" {
  description = "Optional. If empty, module generates name"
  type        = string
  default     = ""
}
