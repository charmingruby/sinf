variable "s3_key_lambda_prefix" {
  description = "Prefix for the S3 key for the lambda code"
  type        = string
  default     = "lambdas"
}
variable "lambdas_definition" {
  description = "List of lambdas with own http definitions"
  type = list(object({
    name   = string
    path   = string
    method = string
  }))
}
