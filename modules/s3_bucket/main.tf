resource "aws_s3_bucket" "landing_zone" {
  bucket_prefix = "${var.environment}-${lower(replace(var.name, "_", "-"))}-landing-zone"

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 0
    enabled                                = true
    id                                     = "InfrequentAccessRule"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "landing_zone" {
  bucket                  = aws_s3_bucket.landing_zone.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
