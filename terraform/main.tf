module "serverless" {
  source       = "./modules/serverless"
  lambdas      = var.lambdas
  project_name = var.project_name
}
