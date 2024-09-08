
resource "aws_s3_bucket" "bucket_s3" {
  bucket = "recommendation-social-media-app-s3-bucket"

  tags = {
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket_s3.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions = [ "s3:GetObject" ]
    resources = [ "${aws_s3_bucket.bucket_s3.arn}/*" ]
    
    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = ["arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.cloudfront_distribution_id}"]
    }
  }
}