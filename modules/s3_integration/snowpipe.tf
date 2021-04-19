resource "time_sleep" "iam_propagation" {
  depends_on = [
    aws_iam_role.snowflake_s3,
    aws_iam_role_policy_attachment.snowflake_s3,
  ]

  create_duration = "10s"
}

resource "snowflake_pipe" "s3_pipe" {
  database       = var.stage_database
  schema         = var.stage_schema
  name           = "${var.name}_PIPE"
  auto_ingest    = true
  comment        = "Snowpipe for ${snowflake_stage.s3_stage.name}"
  copy_statement = var.snowpipe_copy_statement

  depends_on = [time_sleep.iam_propagation]
}

resource "aws_s3_bucket_notification" "s3_pipe" {
  bucket = var.s3_bucket_name

  queue {
    events        = ["s3:ObjectCreated:Put"]
    filter_prefix = "${var.storage_path}/"
    queue_arn     = snowflake_pipe.s3_pipe.notification_channel
  }
}
