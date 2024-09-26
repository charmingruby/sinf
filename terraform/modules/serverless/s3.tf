resource "aws_s3_bucket" "lambda_zip_bucket" {
  bucket = "${var.project_resource_naming}-lambdas-zip-bucket"
}

resource "aws_s3_object" "lambda_zip_object_bucket" {
  for_each = { for lambda in var.lambdas : lambda.name => lambda }

  depends_on = [null_resource.build_lambda]
  bucket     = aws_s3_bucket.lambda_zip_bucket.bucket
  key        = each.key
  source     = "dist/${each.key}.zip"
}
