terraform {
  backend "s3" {
    bucket = "sinf-iac"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
