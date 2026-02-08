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

variable "vpc_cidr" {
  type = string
}
variable "azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}
variable "private_subnet_cidrs" {
  type = list(string)
}

# Ports (defaults)
variable "http_port" {
  type    = number
  default = 80
}
variable "https_port" {
  type    = number
  default = 443
}
variable "mysql_port" {
  type    = number
  default = 3306
}
variable "nfs_port" {
  type    = number
  default = 2049
}

variable "node_exporter_port" {
  type    = number
  default = 9100
}
variable "grafana_port" {
  type    = number
  default = 3000
}
