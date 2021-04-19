resource "snowflake_stage" "s3_stage" {
  name                = "STG_LANDING_${var.name}"
  file_format         = "TYPE = JSON"
  storage_integration = snowflake_storage_integration.s3_integration.name
  url                 = "s3://${var.s3_bucket_name}/${var.storage_path}"
  database            = var.stage_database
  schema              = var.stage_schema

    lifecycle {
    ignore_changes = [file_format]
  }
}

resource "snowflake_stage_grant" "s3_stage" {
  database_name = var.stage_database
  schema_name   = var.stage_schema
  stage_name    = snowflake_stage.s3_stage.name
  roles         = ["SYSADMIN", "ACCOUNTADMIN"]
}
