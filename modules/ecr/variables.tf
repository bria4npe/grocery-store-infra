variable "project" {
  type = string
}

variable "services" {
  type        = list(string)
  description = "List of services to create ECR repos for"
}

variable "suffix" {
  type        = string
  default     = ""
  description = "Optional suffix e.g. -stg for staging"
}

variable "tags" {
  type    = map(string)
  default = {}
}
