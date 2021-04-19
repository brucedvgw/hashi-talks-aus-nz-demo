
resource "aws_iam_policy" "snowflake_s3" {
  name        = "${var.environment}-snowflake-${lower(var.name)}"
  path        = "/"
  description = "Snowflake policy used for S3 integration for ${var.environment}-${lower(replace(var.name, "_", "-"))}-landing-zone"

  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "s3:GetObject*",
            "s3:GetObjectVersion*"
          ],
          Resource = [
            data.aws_s3_bucket.selected.arn,
            "${data.aws_s3_bucket.selected.arn}/*"
          ]
        },
        {
          Effect = "Allow",
          Action = [
            "s3:ListBucket"
          ],
          Resource = [
            data.aws_s3_bucket.selected.arn,
            "${data.aws_s3_bucket.selected.arn}/*"
          ]
          Condition = {
            "StringLike" = {
              "s3:prefix" : ["*"]
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_role" "snowflake_s3" {
  name = "${var.environment}-snowflake-${lower(var.name)}"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid    = "snowflake",
          Effect = "Allow",
          Principal = {
            AWS = snowflake_storage_integration.s3_integration.storage_aws_iam_user_arn
          },
          Action = "sts:AssumeRole",
          Condition = {
            StringEquals = {
              "sts:ExternalId" = snowflake_storage_integration.s3_integration.storage_aws_external_id
            }
          }
        }
      ]
    }
  )

  depends_on = [snowflake_storage_integration.s3_integration]
}

resource "aws_iam_role_policy_attachment" "snowflake_s3" {
  role       = aws_iam_role.snowflake_s3.name
  policy_arn = aws_iam_policy.snowflake_s3.arn
}
