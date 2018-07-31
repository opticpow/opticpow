################################################################################
#
# # Specify the provider and access details
#

provider "aws" {
  region  = "${var.aws_region}"
  profile = "opticpow"
}

provider "aws" {
  alias   = "ingramsensei"
  region  = "${var.aws_region}"
  profile = "ingramsensei"
}

provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = "opticpow"
}

# vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab autoindent:
