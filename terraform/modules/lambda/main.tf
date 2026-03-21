resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  runtime       = "nodejs18.x"
  handler       = "handler.handler"

  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)

  role = var.lambda_role_arn

  timeout = 3
}