locals {
  service_name = "api-gateway-sample-credentials"
}

provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "~/.aws/${local.service_name}"
}
