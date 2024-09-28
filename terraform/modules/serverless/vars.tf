variable "project_resource_naming" {
  description = "Name of the project to be used for naming resources"
  type        = string
}

variable "tags" {
  description = "Common tags to be used for all resources"
  type = object({
    Project    = string
    Department = string
  })
}

variable "s3_key_lambda_prefix" {
  description = "Prefix for the S3 key for the lambda code"
  type        = string
  default     = "lambdas"
}
variable "lambdas" {
  description = "List of lambdas with definitions"
  type = list(object({
    name        = string
    path        = string
    method      = string
    memory_size = number
  }))
}

variable "aws_account_id" {
  description = "AWS Accont ID"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}
