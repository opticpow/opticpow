################################################################################
#
# # Specify the provider and access details
#

provider "aws" {
  region  = "${var.aws_region}"
  profile = "personal"
}

provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = "personal"
}

# vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab autoindent:
