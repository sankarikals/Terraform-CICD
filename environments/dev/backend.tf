terraform {
  backend "s3" {
    bucket         = "terraform-project-state-dev"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-project-locks-dev"
  }
}