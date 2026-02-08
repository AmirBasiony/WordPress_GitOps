variable "name_prefix" {
  description = "Prefix for naming ALB resources"
  type        = string
}

variable "owner" {
  description = "Owner tag value"
  type        = string
}

variable "tags" {
  description = "Extra tags applied to resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID where ALB target group is created"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener"
  type        = string
}

variable "web_instance_ids" {
  description = "List of EC2 instance IDs to attach to target group"
  type        = list(string)
}

variable "target_port" {
  description = "Target group port"
  type        = number
  default     = 80
}

# Healthcheck inputs
variable "healthcheck_path" {
  description = "Healthcheck path"
  type        = string
  default     = "/health"
}

variable "healthy_threshold" {
  description = "Healthy threshold"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Unhealthy threshold"
  type        = number
  default     = 2
}

variable "healthcheck_timeout" {
  description = "Healthcheck timeout (seconds)"
  type        = number
  default     = 5
}

variable "healthcheck_interval" {
  description = "Healthcheck interval (seconds)"
  type        = number
  default     = 30
}
