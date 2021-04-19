terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.23.0"
    }
  }
}

resource "snowflake_database" "this" {
  name = var.database_name
}

resource "snowflake_database_grant" "modify" {
  database_name = snowflake_database.this.name
  privilege     = "MODIFY"
  roles         = ["SYSADMIN", "ACCOUNTADMIN"]
}

resource "snowflake_database_grant" "usage" {
  database_name = snowflake_database.this.name
  privilege     = "USAGE"
  roles         = ["SYSADMIN", "ACCOUNTADMIN"]
}

resource "snowflake_schema_grant" "modify" {
  database_name = snowflake_database.this.name
  privilege     = "MODIFY"
  roles         = ["SYSADMIN", "ACCOUNTADMIN"]
  on_future     = true

}

resource "snowflake_schema_grant" "usage" {
  database_name = snowflake_database.this.name
  privilege     = "USAGE"
  roles         = ["SYSADMIN", "ACCOUNTADMIN"]
  on_future     = true

}

resource "snowflake_table_grant" "Update" {
  database_name = snowflake_database.this.name
  privilege     = "UPDATE"
  roles         = ["SYSADMIN", "ACCOUNTADMIN"]
  on_future     = true

}

resource "snowflake_table_grant" "select" {
  database_name = snowflake_database.this.name
  privilege     = "SELECT"
  roles         = ["SYSADMIN", "ACCOUNTADMIN"]
  on_future     = true

}

resource "snowflake_view_grant" "select" {
  database_name = snowflake_database.this.name
  privilege     = "SELECT"
  roles         = ["SYSADMIN", "ACCOUNTADMIN"]
  on_future     = true
}

resource "snowflake_schema" "raw" {
  name     = "RAW"
  comment  = "Raw data loaded from S3"
  database = snowflake_database.this.name

  depends_on = [snowflake_schema_grant.usage, snowflake_schema_grant.modify]
}

resource "snowflake_schema" "curated" {
  name     = "CURATED"
  comment  = "Cleaned data. Ready for consumption"
  database = snowflake_database.this.name

  depends_on = [snowflake_schema_grant.usage, snowflake_schema_grant.modify]
}


