terraform {
  backend "s3" {
    bucket  = "terraform-state-terraformcicd"
    key     = "dev/terraform.tfstate"
    dynamodb_table = "terraform-lock-dev"
    region  = "us-east-1"
    encrypt = true
  }
}
