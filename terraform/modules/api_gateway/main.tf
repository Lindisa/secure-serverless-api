resource "aws_apigatewayv2_api" "api" {
  name          = "secure-api"
  protocol_type = "HTTP"
}

resource "aws_api_gateway_api_key" "key" {
  name = "secure-api-key"
}

resource "aws_api_gateway_usage_plan" "plan" {
  name = "secure-usage-plan"

  api_stages {
    api_id = aws_apigatewayv2_api.api.id
    stage  = "$default"
  }
}

resource "aws_api_gateway_usage_plan_key" "plan_key" {
  key_id        = aws_api_gateway_api_key.key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.plan.id
}