terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Environment = "dev"
      Terraform   = "true"
      Project     = "WebServer"
    }
  }
}

module "s3_backend" {
  source = "../../modules/s3-backend"
  
  bucket_name          = "${var.project_name}-terraform-state-dev"
  dynamodb_table_name = "${var.project_name}-terraform-locks-dev"
  force_destroy       = true
  
  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"
  
  environment          = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "security_group" {
  source = "../../modules/security-group"
  
  environment    = var.environment
  vpc_id        = module.vpc.vpc_id
  allowed_ports = var.allowed_ports
  
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "iam_role" {
  source = "../../modules/iam-role"
  
  environment       = var.environment
  attach_ssm_policy = true
  
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "ec2" {
  source = "../../modules/ec2"
  
  environment                = var.environment
  instance_type             = var.instance_type
  subnet_id                 = module.vpc.public_subnet_ids[0]
  security_group_id         = module.security_group.security_group_id
  iam_instance_profile_name = module.iam_role.iam_instance_profile_name
  allocate_eip              = true
  
  user_data = templatefile("${path.module}/user-data.sh", {
    environment = var.environment
    message     = "This is dev server from dev"
  })
  
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}