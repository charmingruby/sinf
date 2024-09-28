variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS Accont ID"
  type        = string
}

variable "project_resource_naming" {
  description = "Project name to be used for naming resources"
  type        = string
}

variable "lambdas" {
  description = "List of lambdas with own http definitions"
  type = list(object({
    name        = string
    path        = string
    method      = string
    memory_size = number
  }))
}
