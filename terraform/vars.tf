variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type = string
}

variable "lambdas_definition" {
  description = "List of lambdas with own http definitions"
  type = list(object({
    name   = string
    path   = string
    method = string
  }))
}
