resource "aws_api_gateway_rest_api" "api_rest" {
  name        = "${var.prefix}-terraform-api_gateway"
  description = "Receive requests to our API on GSuite automation"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_method" "api_gateway_method" {
  authorization    = "NONE"
  http_method      = "POST"
  resource_id      = aws_api_gateway_rest_api.api_rest.root_resource_id
  rest_api_id      = aws_api_gateway_rest_api.api_rest.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_rest.id
  resource_id = aws_api_gateway_rest_api.api_rest.root_resource_id
  http_method = aws_api_gateway_method.api_gateway_method.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api_rest.id
  resource_id = aws_api_gateway_rest_api.api_rest.root_resource_id
  http_method = aws_api_gateway_method.api_gateway_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "api_gateway_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api_rest.id
  resource_id = aws_api_gateway_rest_api.api_rest.root_resource_id
  http_method = aws_api_gateway_method.api_gateway_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.api_rest.id
  stage_name = "${var.prod_stage}"

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api_rest.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_api_gateway_stage" "api_gateway_stage" {
#   deployment_id = aws_api_gateway_deployment.api_gateway_deployment.id
#   rest_api_id   = aws_api_gateway_rest_api.api_rest.id
#   stage_name    = "${var.prod_stage}"
# }

resource "aws_api_gateway_api_key" "api_gateway_api_key" {
  name = "${var.prefix}-terraform-api_key"
}

resource "aws_api_gateway_usage_plan" "api_gateway_usage_plan" {
  name         = "${var.prefix}-terraform-usage_plan"
  description  = "Usage plan for API requests"

  api_stages {
    api_id = aws_api_gateway_rest_api.api_rest.id
    stage  = aws_api_gateway_deployment.api_gateway_deployment.stage_name
  }

  quota_settings {
    limit  = 100000
    period = "MONTH"
  }

  throttle_settings {
    burst_limit = 500
    rate_limit  = 1000
  }
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.api_gateway_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.api_gateway_usage_plan.id
}