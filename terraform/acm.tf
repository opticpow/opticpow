resource "aws_acm_certificate" "opticpow_io" {
  provider = "aws.us-east-1"
  domain_name = "opticpow.io"
  validation_method = "DNS"
}
