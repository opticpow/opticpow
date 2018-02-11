################################################################################
#
# variable Definitions
#

variable "project_name" {
  description = "The Terraform Project Name"
  default     = "opticpow"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "ap-southeast-2"
}

variable "ttl" {
  description = "DNS TTL"
  default     = "300"
}

# vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab autoindent:
