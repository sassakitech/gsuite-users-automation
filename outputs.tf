output "api_gateway_stage_invokeurl" {
  value = aws_api_gateway_deployment.api_gateway_deployment.invoke_url
}

output "get_api_key_value" {
  value     = aws_api_gateway_api_key.api_gateway_api_key.name
}
