variable "integration_name" {
  type        = string
  description = "Name of the Snowflake Storage integration"
}

variable "storage_path" {
  type        = string
  description = "The path for which the storage integration will pull data from e.g. /folder-a"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Environment name E.g. `dev`, `test` or `production`"
}

variable "stage_database" {
  type        = string
  description = "The database in which to create the stage"
}

variable "stage_schema" {
  type        = string
  description = "The schema in which to create the stage"
}

variable "name" {
  type        = string
  description = "Namespace for the resource"
}

variable "snowpipe_copy_statement" {
  type        = string
  description = "Specifies the copy statement for the pipe."
  default     = ""
}

variable "s3_bucket_name" {
  type        = string
  description = "The S3 bucket name that the Storage Integration will connect to"
}
