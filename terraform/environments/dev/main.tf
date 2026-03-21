module "cognito" {
  source         = "../../modules/cognito"
  user_pool_name = "serverless-users"
  client_name    = "serverless-client"
}

module "lambda" {
  source          = "../../modules/lambda"
  function_name   = "secure-api-lambda"
  filename        = "../../lambda/function.zip"
  lambda_role_arn = "arn:aws:iam::123456789012:role/dummy-role"
}

module "api_gateway" {
  source            = "../../modules/api_gateway"
  lambda_invoke_arn = module.lambda.invoke_arn
}

module "cloudfront" {
  source          = "../../modules/cloudfront"
  api_gateway_url = module.api_gateway.invoke_url
}