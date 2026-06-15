variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name used as prefix for all resources"
  type        = string
  default     = "grocery-store"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
