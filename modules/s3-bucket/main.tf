resource "aws_s3_bucket" "example" {
  bucket = "project-ci-bucket-${random_id.random.hex}"
}

resource "random_id" "random" {
  byte_length = 8
}