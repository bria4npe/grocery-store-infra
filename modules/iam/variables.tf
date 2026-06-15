variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "roles" {
  type = map(object({
    assume_role_policy = string
    policy_arns        = list(string)
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
