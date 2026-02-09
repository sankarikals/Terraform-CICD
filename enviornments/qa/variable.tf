variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "allowed_ports" {
  description = "Allowed inbound ports for QA"
  type        = list(number)
}

variable "account_id" {
  type = string
  
}

variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

/*
variable "environment" {
  type    = string
  default = "qa"
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

*/
