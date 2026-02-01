variable "environment" {
  description = "Environment name"
  type        = string
}

variable "attach_ssm_policy" {
  description = "Whether to attach SSM policy to the role"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}