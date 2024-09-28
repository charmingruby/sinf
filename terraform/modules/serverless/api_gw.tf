resource "aws_apigatewayv2_api" "this" {
  name          = "${var.project_resource_naming}-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "this" {
  for_each = { for lambda in var.lambdas : lambda.name => lambda }

  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.this[each.value.name].invoke_arn
}

resource "aws_apigatewayv2_route" "this" {
  for_each = { for lambda in var.lambdas : lambda.name => lambda }

  api_id    = aws_apigatewayv2_api.this.id
  route_key = "${upper(each.value.method)} ${each.value.path}"
  target    = "integrations/${aws_apigatewayv2_integration.this[each.value.name].id}"
}

resource "aws_lambda_permission" "this" {
  for_each = { for lambda in var.lambdas : lambda.name => lambda }

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this[each.key].arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_apigatewayv2_api.this.id}/*/*"
}
