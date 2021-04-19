resource "snowflake_storage_integration" "s3_integration" {
  name                      = var.integration_name
  storage_provider          = "S3"
  storage_aws_role_arn      = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.environment}-snowflake-${lower(var.name)}"
  storage_allowed_locations = ["s3://${var.s3_bucket_name}/${var.storage_path}"]

  lifecycle {
    ignore_changes = [type] // known issue - https://github.com/chanzuckerberg/terraform-provider-snowflake/issues/204
  }
}

resource "snowflake_integration_grant" "s3_integration" {
  integration_name = snowflake_storage_integration.s3_integration.name
  roles            = ["SYSADMIN", "ACCOUNTADMIN"]
  lifecycle {
    ignore_changes = [roles]
  }
}
