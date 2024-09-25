module "serverless" {
  source             = "./modules/serverless"
  lambdas_definition = var.lambdas_definition
  project_name       = var.project_name
}
