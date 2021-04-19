variable "environment" {
  type        = string
  description = "Environment name E.g. `dev`, `test` or `production`"
}

variable "name" {
  type        = string
  description = "The name of the S3 bucket"
}

variable "tags" {
  type    = map(string)
  default = {}
}
