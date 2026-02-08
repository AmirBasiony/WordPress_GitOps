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

variable "web_servers" {
  type = map(object({
    name      = string
    subnet_id = string
  }))
}

variable "mysql_subnet_id" { type = string }

variable "wp_ami" {
  type    = string
  default = "ami-04ac22cc531f2fd24"
}
variable "db_ami" {
  type    = string
  default = "ami-0c398cb65a93047f2"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "web_sg_id" {
  type = string
}
variable "mysql_sg_id" {
  type = string
}

variable "app_instance_profile_name" {
  type = string
}
variable "mysql_instance_profile_name" {
  type = string
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "user_data_path" {
  description = "Relative to root module"
  type        = string
  default     = "scripts/install_ssm_agent.sh"
}
variable "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  type        = string
}