variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "default_az" {
  description = "The default availability zone to use for resources"
  type        = string
  default     = "us-east-1a"
}