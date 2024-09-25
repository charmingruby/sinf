resource "null_resource" "build_lambda" {
  for_each = { for idx, lambda in var.lambdas : idx => lambda }

  provisioner "local-exec" {
    command = <<EOT
      mkdir -p bin
      mkdir -p dist
      GOOS=linux GOARCH=amd64 go build -o bin/${each.value.name} function/${each.value.name}/main.go
      zip -j dist/${each.value.name}.zip bin/${each.value.name}
    EOT
  }
}

resource "aws_s3_object" "lambda_zip_bucket" {
  for_each   = { for idx, lambda in var.lambdas : idx => lambda }
  depends_on = [null_resource.build_lambda]

  bucket = "lambdas-zip-bucket"
  key    = "${var.s3_key_lambda_prefix}/${each.value.name}.zip"
  source = "dist/${each.value.name}.zip"
}

resource "aws_lambda_function" "lambda" {
  for_each   = { for idx, lambda in var.lambdas : idx => lambda }
  depends_on = [aws_s3_object.lambda_zip_bucket]

  function_name = each.value.name
  s3_bucket     = aws_s3_object.lambda_zip_bucket[each.value.name].bucket
  s3_key        = aws_s3_object.lambda_zip_bucket[each.value.name].key
  handler       = "main"
  runtime       = "go1.x"
  role          = data.aws_iam_policy_document.lambda_assume_role
}
