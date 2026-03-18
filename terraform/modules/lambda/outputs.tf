output "invoke_arn" {
  description = "Lambda invoke ARN"
  value       = aws_lambda_function.lambda.invoke_arn
}