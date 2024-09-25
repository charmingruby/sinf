variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_account_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "lambdas" {
  description = "List of lambdas with own http definitions"
  type = list(object({
    name   = string
    path   = string
    method = string
  }))
}
