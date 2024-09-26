module "serverless" {
  source         = "./modules/serverless"
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id
  lambdas        = var.lambdas
  project_name   = var.project_name
}

output "api_gateway_url" {
  value = module.serverless.api_gateway_url
}
