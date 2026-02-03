module "vpc" {
  source = "../../modules/vpc"
  
  environment = var.environment
  vpc_cidr    = "10.0.0.0/16"
  
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  
  availability_zones = ["us-east-1a", "us-east-1b"]
  
  tags = {
    Environment = var.environment
    Team        = "DevOps"
    Owner       = "Development"
  }
}

module "security_group" {
  source = "../../modules/security_group"

  name          = "qa"
  vpc_id        = module.vpc.vpc_id
  allowed_ports = var.allowed_ports

  tags = {
    Environment = "qa"
  }
}

output "security_group_id" {
  value = module.security_group.security_group_id
}


module "iam_role_ssm" {
  source = "../../modules/iam-role"

  name = "qa"

  tags = {
    Environment = "qa"
  }
}

module "ec2" {
  source = "../../modules/ec2"
  #for_each      = toset(module.vpc.public_subnet_ids)
  count = length(module.vpc.public_subnet_ids)


  name                  = var.environment
  environment           = var.environment
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  subnet_id            = module.vpc.public_subnet_ids[count.index]
  #subnet_id             = each.value
  #subnet_id             = module.vpc.public_subnet_id[0]
  security_group_id     = module.security_group.security_group_id
  iam_instance_profile  = module.iam_role_ssm.instance_profile_name

  tags = {
    Environment = var.environment
  }
}
