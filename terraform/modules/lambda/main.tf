resource "aws_lambda_function" "lambda" {

  function_name = var.function_name
  runtime       = "nodejs18.x"
  handler       = "handler.handler"

  filename         = var.lambda_package
  source_code_hash = filebase64sha256(var.lambda_package)

  role = var.lambda_role

  timeout     = 3
  memory_size = 128
}