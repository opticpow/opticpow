################################################################################
#
# opticpow.io Domain
#
resource "aws_route53_zone" "opticpow_io" {
  name = "opticpow.io."
}

# Required by Google for Domain Ownership Proof in Gmail
resource "aws_route53_record" "opticpow_io_google" {
  zone_id = "${aws_route53_zone.opticpow_io.zone_id}"
  name    = "tkkdnra2jmbp"
  type    = "CNAME"
  ttl     = "${var.ttl}"
  records = ["gv-i6crv5agamlupi.dv.googlehosted.com"]
}

resource "aws_route53_record" "opticpow_io_mx" {
  zone_id = "${aws_route53_zone.opticpow_io.zone_id}"
  name    = ""
  type    = "MX"
  ttl     = "${var.ttl}"
  records = [
    "1 aspmx.l.google.com",
    "5 alt1.aspmx.l.google.com",
    "5 alt2.aspmx.l.google.com",
    "10 alt3.aspmx.l.google.com",
    "10 alt4.aspmx.l.google.com"
  ]
}

# Required by keybase for identity
resource "aws_route53_record" "opticpow_io_keybase" {
  zone_id = "${aws_route53_zone.opticpow_io.zone_id}"
  name    = "@"
  type    = "TXT"
  ttl     = "${var.ttl}"
  records = ["keybase-site-verification=LlO9X40NbjhxqIQ11M94ARHwuXOw1xXfaw7qM6Obd3w"]
}

# Website
resource "aws_route53_record" "opticpow_io_website" {
  zone_id = "${aws_route53_zone.opticpow_io.zone_id}"
  name    = "opticpow.io"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.opticpow_io.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.opticpow_io.hosted_zone_id}"
    evaluate_target_health = false
  }
}

################################################################################
#
# opticpow.com Domain
#
resource "aws_route53_zone" "opticpow_com" {
  name = "opticpow.com."
}

# Required by Google for Domain Ownership Proof in Gmail
resource "aws_route53_record" "opticpow_com_google" {
  zone_id = "${aws_route53_zone.opticpow_com.zone_id}"
  name    = "gn5bhn2wyu52"
  type    = "CNAME"
  ttl     = "${var.ttl}"
  records = ["gv-rbhkfrrh23ssls.dv.googlehosted.com"]
}

resource "aws_route53_record" "opticpow_com_mx" {
  zone_id = "${aws_route53_zone.opticpow_com.zone_id}"
  name    = ""
  type    = "MX"
  ttl     = "${var.ttl}"
  records = [
    "1 aspmx.l.google.com",
    "5 alt1.aspmx.l.google.com",
    "5 alt2.aspmx.l.google.com",
    "10 alt3.aspmx.l.google.com",
    "10 alt4.aspmx.l.google.com"
  ]
}

################################################################################
#
# opticpow.org Domain
#
resource "aws_route53_zone" "opticpow_org" {
  name = "opticpow.org."
}

# Required by Google for Domain Ownership Proof in Gmail
resource "aws_route53_record" "opticpow_org_google" {
  zone_id = "${aws_route53_zone.opticpow_org.zone_id}"
  name    = "6ujb45a6bs2v"
  type    = "CNAME"
  ttl     = "${var.ttl}"
  records = ["gv-ce54zrvae7fion.dv.googlehosted.com"]
}

resource "aws_route53_record" "opticpow_org_mx" {
  zone_id = "${aws_route53_zone.opticpow_org.zone_id}"
  name    = ""
  type    = "MX"
  ttl     = "${var.ttl}"
  records = [
    "1 aspmx.l.google.com",
    "5 alt1.aspmx.l.google.com",
    "5 alt2.aspmx.l.google.com",
    "10 alt3.aspmx.l.google.com",
    "10 alt4.aspmx.l.google.com"
  ]
}

################################################################################
#
# ingram.net.au Domain
#
resource "aws_route53_zone" "ingram_net_au" {
  name = "ingram.net.au."
}

resource "aws_route53_record" "ingram_net_au_mx" {
  zone_id = "${aws_route53_zone.ingram_net_au.zone_id}"
  name    = ""
  type    = "MX"
  ttl     = "${var.ttl}"
  records = [
    "1 aspmx.l.google.com",
    "5 alt1.aspmx.l.google.com",
    "5 alt2.aspmx.l.google.com",
    "10 alt3.aspmx.l.google.com",
    "10 alt4.aspmx.l.google.com"
  ]
}

# Google Docs
resource "aws_route53_record" "ingram_net_au_docs" {
  zone_id = "${aws_route53_zone.ingram_net_au.zone_id}"
  name    = "docs"
  type    = "CNAME"
  ttl     = "${var.ttl}"
  records = ["ghs.googlehosted.com"]
}

# Google Gmail
resource "aws_route53_record" "ingram_net_au_mail" {
  zone_id = "${aws_route53_zone.ingram_net_au.zone_id}"
  name    = "mail"
  type    = "CNAME"
  ttl     = "${var.ttl}"
  records = ["ghs.googlehosted.com"]
}

# Google Calendar
resource "aws_route53_record" "ingram_net_au_cal" {
  zone_id = "${aws_route53_zone.ingram_net_au.zone_id}"
  name    = "cal"
  type    = "CNAME"
  ttl     = "${var.ttl}"
  records = ["ghs.googlehosted.com"]
}

resource "aws_route53_record" "ingram_net_au_photos" {
  zone_id = "${aws_route53_zone.ingram_net_au.zone_id}"
  name    = "photos"
  type    = "CNAME"
  ttl     = "${var.ttl}"
  records = ["domains.smugmug.com"]
}

resource "aws_route53_record" "ingram_net_au_photo" {
  zone_id = "${aws_route53_zone.ingram_net_au.zone_id}"
  name    = "photo"
  type    = "CNAME"
  ttl     = "${var.ttl}"
  records = ["domains.smugmug.com"]
}

resource "aws_route53_record" "ingram_net_au_love" {
  zone_id = "${aws_route53_zone.ingram_net_au.zone_id}"
  name    = "love"
  type    = "CNAME"
  ttl     = "${var.ttl}"
  records = ["ingram.net.au"]
}

################################################################################
#
# ingramsensei Domain
#
resource "aws_route53_zone" "ingramsensei_com" {
  name = "ingramsensei.com."
}

# Required by Google for Domain Ownership Proof in Gmail
resource "aws_route53_record" "ingramsensei_com_google" {
  zone_id = "${aws_route53_zone.ingramsensei_com.zone_id}"
  name    = "ingramsensei.com."
  type    = "TXT"
  ttl     = "${var.ttl}"
  records = ["google-site-verification=YCEbhH27GTxF8PExknPdbvpXOPkfQ_mxfEG0prU0ysA"]
}

resource "aws_route53_record" "ingramsensei_com_mx" {
  zone_id = "${aws_route53_zone.ingramsensei_com.zone_id}"
  name    = ""
  type    = "MX"
  ttl     = "${var.ttl}"
  records = [
    "1 aspmx.l.google.com",
    "5 alt1.aspmx.l.google.com",
    "5 alt2.aspmx.l.google.com",
    "10 alt3.aspmx.l.google.com",
    "10 alt4.aspmx.l.google.com"
  ]
}

resource "aws_route53_record" "ingramsensei_com_apex" {
  zone_id = "${aws_route53_zone.ingramsensei_com.zone_id}"
  name    = "ingramsensei.com."
  type    = "A"
  ttl     = "${var.ttl}"
  records = ["13.54.141.219"]
}
