data "aws_acm_certificate" "app_cert" {
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

# data "aws_acm_certificate" "app_cert" {
#   arn = "arn:aws:acm:us-east-1:753675398055:certificate/bd30cbae-a768-4dd9-9d9b-d96c470806ea"
# }
