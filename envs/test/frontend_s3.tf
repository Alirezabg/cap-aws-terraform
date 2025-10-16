# s3 for frontend
variable "region" {
  type    = string
  default = "eu-west-2"
}

resource "aws_s3_bucket" "frontend_web" {
  bucket = "onlineshop-cap-frontend-web-${var.region}-test"
}

resource "aws_s3_bucket_public_access_block" "frontend_web" {
  bucket                  = aws_s3_bucket.frontend_web.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "frontend_web" {
  bucket = aws_s3_bucket.frontend_web.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_website_configuration" "frontend_web" {
  bucket = aws_s3_bucket.frontend_web.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

data "aws_iam_policy_document" "public_read" {
  statement {
    sid     = "PublicReadGetObject"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = ["${aws_s3_bucket.frontend_web.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "frontend_web" {
  bucket     = aws_s3_bucket.frontend_web.id
  policy     = data.aws_iam_policy_document.public_read.json
  depends_on = [aws_s3_bucket_public_access_block.frontend_web]
}

output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend_web.id
}

output "frontend_website_url" {
  value = aws_s3_bucket_website_configuration.frontend_web.website_endpoint
}