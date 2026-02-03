variable "name" {
  description = "IAM role name prefix"
  type        = string
}

variable "tags" {
  description = "Tags for IAM role"
  type        = map(string)
  default     = {}
}
