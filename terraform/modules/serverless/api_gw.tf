resource "aws_apigatewayv2_api" "this" {
  name          = "${var.project_name}-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambdas_integration" {
  for_each = { for lambda in var.lambdas : lambda.name => lambda }

  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.lambdas[each.value.name].invoke_arn
}

resource "aws_apigatewayv2_route" "lambdas_route" {
  for_each = { for lambda in var.lambdas : lambda.name => lambda }

  api_id    = aws_apigatewayv2_api.this.id
  route_key = "${upper(each.value.method)} ${each.value.path}"
  target    = "integrations/${aws_apigatewayv2_integration.lambdas_integration[each.value.name].id}"
}
