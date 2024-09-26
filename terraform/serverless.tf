module "serverless" {
  source         = "./modules/serverless"
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id
  project_name   = var.project_resource_naming
  lambdas        = var.lambdas
  tags           = local.tags
}

output "api_gateway_url" {
  value = module.serverless.api_gateway_url
}
