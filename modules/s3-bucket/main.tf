resource "aws_s3_bucket" "s3_project_bucket" {
  bucket = "project-ci-bucket-${random_id.random.hex}"
}

resource "random_id" "random" {
  byte_length = 8
}