module "iam" {
  source = "../../modules/iam"

  role_name = "secure-api-lambda-role"
}

resource "time_sleep" "wait_for_iam" {
  depends_on = [module.iam]

  create_duration = "20s"
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"

  lambda_name = "secure-api-lambda"
}

module "lambda" {
  source = "../../modules/lambda"

  function_name  = "secure-api-lambda"
  lambda_package = "../../../lambda/function.zip"

  lambda_role    = module.iam.lambda_role_arn
  log_group_name = module.cloudwatch.log_group_name

  depends_on = [time_sleep.wait_for_iam]
}

module "dynamodb" {
  source = "../../modules/dynamodb"

  table_name = "secure-api-table"
}

module "api_gateway" {
  source = "../../modules/api_gateway"

  api_name          = "secure-serverless-api"
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
}
module "cognito" {
  source = "../../modules/cognito"

  user_pool_name = "secure-api-users"
  client_name    = "secure-api-client"
}

module "cloudfront" {
  source = "../../modules/cloudfront"

  api_gateway_url = module.api_gateway.api_endpoint
}