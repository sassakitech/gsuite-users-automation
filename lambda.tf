resource "aws_lambda_function" "lambda_function" {
  function_name = "${var.prefix}-terraform-lambda"
  description   = "Lambda function for GSuite automation"
  s3_bucket     = aws_s3_bucket_object.lambda_file_upload.bucket
  s3_key        = aws_s3_bucket_object.lambda_file_upload.key
  # source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  role    = aws_iam_role.iam_role.arn
  runtime = "python3.8"
  handler = "lambda_function.lambda_handler"
  timeout = 120

  environment {
    variables = {
      PARAM_KEY = aws_ssm_parameter.ssm.name
      REGION    = var.aws_region
      SUBJECT   = var.delegated_account
    }
  }
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api_rest.execution_arn}/*/*"
}