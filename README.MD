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

To provision type:

```shell
terraform apply
```