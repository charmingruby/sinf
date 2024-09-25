resource "aws_cloudwatch_log_group" "this" {
  for_each = aws_lambda_function.lambdas

  name              = "/aws/lambda/${each.value["lambda_name"]}"
  retention_in_days = 3
}
