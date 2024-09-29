resource "null_resource" "build_lambda" {
  for_each = { for lambda in var.lambdas : lambda.name => lambda }

  provisioner "local-exec" {
    command = <<EOT
      mkdir -p bin
      mkdir -p dist
      GOOS=linux CGO_ENABLED=0 GOARCH=amd64 go build -tags lambda.norpc -o bin/bootstrap ../function/${each.value.name}/main.go
      zip -j dist/${each.value.name}.zip bin/bootstrap
    EOT
  }
}

resource "aws_lambda_function" "this" {
  for_each   = { for lambda in var.lambdas : lambda.name => lambda }
  depends_on = [aws_s3_object.this]

  function_name = each.value.name
  s3_bucket     = aws_s3_object.this[each.key].bucket
  s3_key        = aws_s3_object.this[each.key].key
  handler       = "bootstrap"
  runtime       = "provided.al2"
  role          = aws_iam_role.lambda_role.arn
  memory_size   = each.value.memory_size

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      LOG_GROUP = "/aws/lambda/${each.key}"
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_resource_naming}-${each.key}-lambda-function"
    }
  )
}
