output "s3_bucket" {
  value = aws_s3_bucket.s3_bucket
}

output "s3_bucket_id" {
  value = aws_s3_bucket.s3_bucket.id
}