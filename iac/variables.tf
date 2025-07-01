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


variable "account_id" {
  description = "The AWS account ID where resources will be deployed"
  type        = string
  default     = "557690605188"
}