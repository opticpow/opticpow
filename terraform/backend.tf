terraform {
  backend "s3" {
    bucket  = "opticpow-terraform"
    key     = "blog"
    region  = "ap-southeast-2"
  }
}

# vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab autoindent:
