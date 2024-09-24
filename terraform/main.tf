module "serverless" {
  source             = "./modules/serverless"
  lambdas_definition = var.lambdas_definition
}
