variable "name" {
  description = "Security group name prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "allowed_ports" {
  description = "List of inbound ports"
  type        = list(number)
}

variable "tags" {
  description = "Tags for security group"
  type        = map(string)
  default     = {}
}
