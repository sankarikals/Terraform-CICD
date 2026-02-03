provider "aws" {
  region = "us-east-1"
}

module "s3_backend" {
  source      = "../../modules/s3-backend"
  environment = "dev"
  account_id  = "530743905801"
}
