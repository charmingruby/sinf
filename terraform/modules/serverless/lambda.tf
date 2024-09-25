resource "null_resource" "build_lambda" {
  for_each = { for lambda in var.lambdas : lambda.name => lambda }

  provisioner "local-exec" {
    command = <<EOT
      mkdir -p bin
      mkdir -p dist
      GOOS=linux GOARCH=amd64 go build -o bin/${each.value.name} ../function/${each.value.name}/main.go
      cp bin/${each.value.name} bin/bootstrap
      zip -j dist/bootstrap.zip bin/bootstrap
    EOT
  }
}

resource "aws_s3_bucket" "lambda_zip_bucket" {
  bucket = "${var.project_name}-lambdas-zip-bucket"
}

resource "aws_s3_object" "lambda_zip_object_bucket" {
  for_each   = { for lambda in var.lambdas : lambda.name => lambda }
  depends_on = [null_resource.build_lambda]

  bucket = aws_s3_bucket.lambda_zip_bucket.bucket
  key    = "${var.s3_key_lambda_prefix}/${each.key}.zip"
  source = "dist/${each.key}.zip"
}

resource "aws_lambda_function" "lambdas" {
  for_each   = { for lambda in var.lambdas : lambda.name => lambda }
  depends_on = [aws_s3_object.lambda_zip_object_bucket]

  function_name = each.value.name
  s3_bucket     = aws_s3_object.lambda_zip_object_bucket[each.key].bucket
  s3_key        = aws_s3_object.lambda_zip_object_bucket[each.key].key
  handler       = "main"
  runtime       = "provided.al2"
  role          = aws_iam_role.rest_api_role.arn

  tracing_config {
    mode = "Active"
  }
}

resource "aws_lambda_permission" "api" {
  for_each = { for lambda in var.lambdas : lambda.name => lambda }

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambdas[each.key].arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:/*/*"
}
