resource "aws_s3_bucket" "this" {
  bucket = "${var.project_resource_naming}-lambdas"
}

resource "aws_s3_object" "this" {
  for_each = { for lambda in var.lambdas : lambda.name => lambda }

  depends_on = [null_resource.build_lambda]
  bucket     = aws_s3_bucket.this.bucket
  key        = each.key
  source     = "dist/${each.key}.zip"
}
