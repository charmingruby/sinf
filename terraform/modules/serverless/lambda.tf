resource "null_resource" "build_lambda" {
  for_each = { for lambda in var.lambdas : lambda.name => lambda }

  provisioner "local-exec" {
    command = <<EOT
      mkdir -p bin
      mkdir -p dist
      GOOS=linux CGO_ENABLED=0 GOARCH=amd64 go build -o bin/bootstrap ../function/${each.value.name}/main.go
      zip -j dist/${each.value.name}.zip bin/bootstrap
    EOT
  }
}

resource "aws_lambda_function" "lambdas" {
  for_each   = { for lambda in var.lambdas : lambda.name => lambda }
  depends_on = [aws_s3_object.lambda_zip_object_bucket]

  function_name = each.value.name
  s3_bucket     = aws_s3_object.lambda_zip_object_bucket[each.key].bucket
  s3_key        = aws_s3_object.lambda_zip_object_bucket[each.key].key
  handler       = "bootstrap"
  runtime       = "provided.al2"
  role          = aws_iam_role.rest_api_role.arn


  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      LOG_LEVEL = "DEBUG"
      LOG_GROUP = "/aws/lambda/${each.key}"
    }
  }
}
