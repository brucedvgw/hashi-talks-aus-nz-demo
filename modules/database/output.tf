output "database_name" {
  value = snowflake_database.this.name
}

output "raw_schema" {
  value = snowflake_schema.raw.name
}

output "curated_schema" {
  value = snowflake_schema.curated.name
}
