output "ssm_role_name" {
  value = module.iam_role_ssm.role_name
}

output "ssm_role_arn" {
  value = module.iam_role_ssm.role_arn
}

output "ssm_instance_profile_name" {
  value = module.iam_role_ssm.instance_profile_name
}
/*
output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ec2_public_dns" {
  value = module.ec2.public_dns
}

*/

output "dev_ec2_public_ips" {
  value = {
    for k, m in module.ec2 : k => m.public_ip
  }
}

output "dev_ec2_public_dns" {
  value = {
    for k, m in module.ec2 : k => m.public_dns
  }
}


