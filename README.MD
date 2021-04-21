# Automating Snowflakes

This repo was created as suppliment to the HashiTalks 2021 "Automating Snowflake" demonstrate the use of Terraform to create a S3 Snowflake integration.

## Required

* Snowflake account - [Free account available](https://signup.snowflake.com)
* Terraform Cloud - [Free account available](https://app.terraform.io/signup/account)
* AWS - [Free tier availale account available](https://aws.amazon.com/free)\

## Usage

You will need to set up a Terraform User for Snowflake to use.
Here is an example SQL statement to use:

```sql
USE ROLE ACCOUNTADMIN;
CREATE USER TERRAFORM PASSWORD = '********' DEFAULT_ROLE = "ACCOUNTADMIN" MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE "ACCOUNTADMIN" TO USER Terraform;
```

Next create a workspace in Terraform Cloud and add the below `Environment` variables

```text
SNOWFLAKE_ACCOUNT = <FROM YOUR NEWLY CREATED ACCOUNT>
SNOWFLAKE_PASSWORD = <PASSWORD FROM THE ACCOUNT CREATED ABOVE>
SNOWFLAKE_USER = TERRAFORM
AWS_ACCESS_KEY_ID = <FROM YOUR AWS ACCOUNT>
AWS_SECRET_ACCESS_KEY = <FROM YOUR AWS ACCOUNT>
```

Update the Terraform workspace to match the workspace created elg.

```terraform
terraform {
  ....
  backend "remote" {
    organization = "<ADD YOUR ORG HERE>"

    workspaces {
      name = "<ADD YOUR WORKSPACE HERE>"
    }
  }
  ```

* Create an S3 Bucket called `hashitalks-dev-snowflake-demo`in the same region as your Snowflake account

* Create a folder for where your data is going to land called `hello-world`

* To provision type:

```shell
terraform apply
```

* Confirm connection between S3 and Snowflake by typing in a Snowflake Worksheet

```sql
LIST @STG_LANDING_HELLO_WORLD
```

* Confirm that no data exists in the new database

```sql
SELECT * FROM "SNOWFLAKE_HELLO_WORLD"."RAW"."HELLO_WORLD"
```

This should should not error and return empty

* In AWS, drop the contents of `./examples` into the S3 bucket/hello-world path

* Go back to Snowflake and run the below query again to see if data has been pulled to Snowflake from S3

```sql
SELECT * FROM "SNOWFLAKE_HELLO_WORLD"."RAW"."HELLO_WORLD"
```
