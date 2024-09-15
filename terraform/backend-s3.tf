resource "aws_s3_bucket" "backend" {
  bucket = "tf-ryanemcdaniel-management"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend" {
  bucket = aws_s3_bucket.backend.bucket
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "backend" {
  bucket = aws_s3_bucket.backend.bucket
}

resource "aws_s3_bucket_ownership_controls" "backend" {
  bucket = aws_s3_bucket.backend.bucket
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "backend" {
  bucket = aws_s3_bucket.backend.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_policy_document" "backend" {
  version = "2012-10-17"
  statement {
    sid = "AllowRead"
    principals {
      type        = "AWS"
      identifiers = [local.org_management_account_id]
    }
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.backend.arn]
  }
  statement {
    sid = "AllowReadWrite"
    principals {
      type        = "AWS"
      identifiers = [local.org_management_account_id]
    }
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.backend.arn}/*aws-organization.tfstate"]
  }
}

resource "aws_s3_bucket_policy" "backend" {
  bucket = aws_s3_bucket.backend.bucket
  policy = data.aws_iam_policy_document.backend.json
}