module "vpc" {
  source = "../../modules/vpc"
  
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  
  availability_zones = var.availability_zones
  
  tags = {
    Environment = var.environment
    Team        = "DevOps"
    Owner       = "Development"
  }
}

module "security_group" {
  source = "../../modules/security_group"

  name          = var.environment
  vpc_id        = module.vpc.vpc_id
  allowed_ports = var.allowed_ports

  tags = {
    Environment = var.environment
  }
}

output "security_group_id" {
  value = module.security_group.security_group_id
}


module "iam_role_ssm" {
  source = "../../modules/iam-role"

  name = var.environment

  tags = {
    Environment = var.environment
  }
}
/*
module "s3_backend" {
  source      = "../../modules/backendconf"
  environment = var.environment
  account_id = var.account_id
}
*/
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
  associate_public_ip_address = var.associate_public_ip_address
  user_data = templatefile("${path.module}/user_data.tftpl", {
    environment = var.environment
  })

  # user_data = templatefile("${path.module}/user_data.sh")
  tags = {
    Environment = var.environment
  }
  }
