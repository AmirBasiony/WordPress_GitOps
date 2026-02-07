
variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}
variable "wp_ami" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-04ac22cc531f2fd24"  # wordpress custom ami
}

variable "db_ami" {
  description = "AMI ID for Database EC2 instance"
  type        = string
  default     = "ami-0c398cb65a93047f2"  # ubuntu ami
}

variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t2.micro"
}

variable "domain_name" {
  description = "Domain name for ACM certificate"
  default     = "*.cloud-stacks.com"
}

variable "cloudflare_api_token" {
  sensitive = true 
  }

# amir.cloud-stacks.com
variable "subdomain" {  
   default = "amir" 
}

