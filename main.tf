terraform {
  required_version = "= 0.15.0"
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.23.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.37.0"
    }
  }

  backend "remote" {
    organization = "personal-labs"

    workspaces {
      name = "snowflake_dev"
    }
  }

}

provider "snowflake" {
  region = "us-east-1"
}

provider "aws" {
  region = "us-east-1"
}

module "hello_world_database" {
  source        = "./modules/database"
  database_name = "SNOWFLAKE_HELLO_WORLD"
}

resource "snowflake_table" "hello_world_landing" {
  name     = "HELLO_WORLD"
  comment  = "Landing table for snowpipe"
  database = module.hello_world_database.database_name
  schema   = module.hello_world_database.raw_schema
  column {
    name = "CITY"
    type = "VARCHAR(16777216)"
  }
  column {
    name = "STATE"
    type = "VARCHAR(16777216)"
  }
  column {
    name = "POSTCODE"
    type = "VARCHAR(16777216)"
  }
  column {
    name = "SALE_DATE"
    type = "TIMESTAMP_NTZ(9)"
  }
  column {
    name = "PRICE"
    type = "NUMBER(38,0)"
  }

  depends_on = [module.hello_world_database]
}


module "helloworld_s3_integration" {
  source                  = "./modules/s3_integration"
  environment             = var.environment
  name                    = "HELLO_WORLD"
  integration_name        = "SNOWFLAKE_HELLO_WORLD_S3_INT"
  s3_bucket_name          = "hashitalks-dev-snowflake-demo"
  storage_path            = "hello-world"
  stage_database          = module.hello_world_database.database_name
  stage_schema            = module.hello_world_database.raw_schema
  snowpipe_copy_statement = <<-EOC
  COPY INTO ${module.hello_world_database.database_name}.${module.hello_world_database.raw_schema}.${snowflake_table.hello_world_landing.name}
  FROM (
  SELECT 
  parse_json($1):city::VARCHAR(16777216) as CITY,
  parse_json($1):state::VARCHAR(16777216) as STATE,
  parse_json($1):postcode::VARCHAR(16777216) as POSTCODE, 
  parse_json($1):sale_date::TIMESTAMPNTZ as SALE_DATE,
  parse_json($1):price::VARCHAR(16777216) as PRICE
  FROM @${module.hello_world_database.database_name}.${module.hello_world_database.raw_schema}.STG_LANDING_HELLO_WORLD)
  FILE_FORMAT = (type = 'JSON')
  ON_ERROR = 'continue';
  EOC
}
