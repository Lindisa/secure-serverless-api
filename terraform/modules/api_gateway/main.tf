resource "aws_apigatewayv2_api" "api" {
  name          = "secure-api"
  protocol_type = "HTTP"
}

# ---------------------------
# Cognito Authorizer (JWT)
# ---------------------------
resource "aws_apigatewayv2_authorizer" "cognito" {
  api_id          = aws_apigatewayv2_api.api.id
  name            = "cognito-authorizer"
  authorizer_type = "JWT"

  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = [var.cognito_client_id]
    issuer   = var.cognito_issuer
  }
}

# ---------------------------
# Lambda Integration
# ---------------------------
resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.lambda_invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

# ---------------------------
# Route (Protected)
# ---------------------------
resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /"

  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

# ---------------------------
# Stage
# ---------------------------
resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

# ---------------------------
# API Key (for usage control)
# ---------------------------
resource "aws_api_gateway_api_key" "key" {
  name = "secure-api-key"
}

# ---------------------------
# Usage Plan
# ---------------------------
resource "aws_api_gateway_usage_plan" "plan" {
  name = "secure-api-usage-plan"

  api_stages {
    api_id = aws_apigatewayv2_api.api.id
    stage  = aws_apigatewayv2_stage.stage.name
  }

  throttle_settings {
    rate_limit  = 10
    burst_limit = 20
  }
}

# ---------------------------
# Attach API Key to Usage Plan
# ---------------------------
resource "aws_api_gateway_usage_plan_key" "plan_key" {
  key_id        = aws_api_gateway_api_key.key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.plan.id
}