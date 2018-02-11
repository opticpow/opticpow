resource "aws_s3_bucket" "opticpow_io" {
  bucket = "opticpow.io"
  acl    = "public-read"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{
	   "Sid":"PublicReadGetObject",
      "Effect":"Allow",
  	  "Principal": {
        "AWS": "*"
      },
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::opticpow.io/*"
      ]
    }
  ]
}
EOF

  tags {
    Name      = "opticpow.io"
    terraform = "${var.project_name}"
  }
}

resource "aws_s3_bucket" "opticpow_terraform" {
  bucket = "opticpow-terraform"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags {
    Name      = "opticpow-terrform"
    type      = "terraform-state"
    terraform = "${var.project_name}"
  }
}
