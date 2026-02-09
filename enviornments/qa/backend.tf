terraform {
  backend "s3" {
    bucket  = "terraform-state-terraformcicd"
    key     = "qa/terraform.tfstate"
    dynamodb_table = "terraform-lock-qa"
    region  = "us-east-1"
    encrypt = true
  }
}
