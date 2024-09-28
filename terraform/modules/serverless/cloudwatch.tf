resource "aws_cloudwatch_log_group" "this" {
  for_each = { for lambda in var.lambdas : lambda.name => lambda }

  name              = "/aws/lambda/${each.key}"
  retention_in_days = 3

  tags = merge(
    var.tags,
    {
      Name = "${var.project_resource_naming}-${each.key}-lambda-log-group"
    }
  )
}
