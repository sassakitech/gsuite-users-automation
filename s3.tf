# Put the .zip file on files folder (after we will use this to lambda function)

resource "aws_s3_bucket_object" "lambda_file_upload" {
  bucket = "${var.prefix}-terraform-remote-state"
  key    = "gsuite/lambda/${var.lambda_file}"
  source = "${path.module}/files/${var.lambda_file}"
  etag   = filemd5("${path.module}/files/${var.lambda_file}")
}