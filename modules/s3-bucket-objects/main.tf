resource "aws_s3_object" "upload_files" {
  for_each = fileset("./application-code/", "**")
  bucket = var.s3_bucket_id
  key = each.value
  source = "./application-code/${each.value}"
  #etag = filemd5("./documents/${each.value}")
  depends_on = [ var.s3_bucket ]
}