output "bucket_name" {
  value = aws_s3_bucket.landing_zone.id
}

output "bucket_arn" {
  value = aws_s3_bucket.landing_zone.arn
}
